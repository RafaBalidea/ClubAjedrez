# Lógica funcional y arquitectura — Aplicación de gestión de club de ajedrez

## 1. Objetivo

La aplicación gestiona la actividad de un club de ajedrez, incluyendo:

- Club y datos administrativos.
- Personas relacionadas con el club.
- Jugadores del club.
- Equipos.
- Temporadas.
- Categorías.
- Torneos y categorías de torneo.
- Rondas.
- Disponibilidad de jugadores.
- Participación de jugadores.
- Ascensos entre categorías.
- Partidas y resultados.
- Directiva del club.
- Documentos.
- Usuarios, roles y permisos.
- Blog del club.
- Funcionamiento offline mediante caché local.
- Sincronización con el servidor mediante control de versiones.

## 2. Arquitectura

- **Aplicación móvil:** .NET MAUI + Blazor Hybrid.
- **Aplicación web:** Blazor.
- **API:** .NET.
- **Base de datos central:** SQL Server.
- **Base de datos local móvil:** SQLite.
- **Persistencia local web:** IndexedDB.

## 3. Principio fundamental

### El servidor es la fuente de la verdad

SQL Server contiene siempre la versión oficial de los datos.

Los dispositivos móviles y la aplicación web pueden trabajar con una copia local/cache. La caché local no sustituye al servidor.

Cuando existe una discrepancia entre el servidor y la caché local, prevalece siempre el servidor.

## 4. Identificación de registros

Todos los registros sincronizables utilizan `UNIQUEIDENTIFIER / GUID`.

El GUID identifica permanentemente al registro y es el mismo en servidor, API y cachés locales.

## 5. Control de versiones

Los registros sincronizables utilizan:

```text
Version
FechaModificacion
Eliminado
```

### Version

`Version` representa la versión del registro en el servidor. El servidor controla su valor; el cliente nunca decide la versión definitiva.

### FechaModificacion

Indica cuándo se produjo la última modificación. Es información útil, pero no es el mecanismo utilizado para detectar conflictos.

### Eliminado

`Eliminado = 1` representa un borrado lógico cuando sea necesario conservar la información del borrado para las cachés.

## 6. Estrategia de sincronización

La sincronización se mantiene deliberadamente sencilla.

No se utilizará inicialmente:

- `SyncChange`.
- `SyncOperation`.
- Cursores de sincronización.
- Historial completo de operaciones.
- Resolución de conflictos campo por campo.
- Sincronización automática de todos los cambios del servidor.

La prioridad es que nunca se sobrescriba silenciosamente una modificación realizada por otro usuario.

## 7. Carga de datos

Cuando el dispositivo necesita datos:

1. Solicita los datos al servidor.
2. La API devuelve la información.
3. El cliente guarda los datos en caché local.
4. El cliente conserva la `Version` recibida.

No es necesario que el móvil tenga siempre la última versión existente en el servidor. Para esta aplicación no es crítico que una vista pueda mostrar temporalmente información desactualizada.

## 8. Modificación offline

El usuario puede modificar datos sin conexión.

El cliente conserva, como mínimo:

```text
Id
Datos
VersionServidor
PendienteDeGuardar
```

La versión que tenía el cliente cuando comenzó a trabajar con el registro se conserva como versión original para el posterior guardado.

## 9. Guardado en servidor

Cuando existe conexión, el cliente envía a la API:

```text
Id
Datos modificados
VersionOriginal
```

Conceptualmente:

```sql
UPDATE Jugador
SET
    Nombre = @Nombre,
    FechaModificacion = SYSUTCDATETIME(),
    Version = Version + 1
WHERE
    JugadorId = @JugadorId
    AND Version = @VersionOriginal
    AND Eliminado = 0;
```

## 10. Guardado correcto

Si la versión del cliente coincide con la versión del servidor, el servidor acepta la modificación, incrementa `Version` y devuelve el registro actualizado.

Ejemplo:

```text
Versión cliente = 15
Versión servidor = 15

=> guardar
=> nueva versión = 16
```

El cliente actualiza su caché y marca el registro como no pendiente.

## 11. Conflicto de concurrencia

Si otro usuario ha modificado el registro previamente:

```text
Versión cliente = 15
Versión servidor = 16
```

el servidor rechaza la modificación.

No se realiza el `UPDATE` y la API devuelve un conflicto junto con la versión actual del servidor.

## 12. Comportamiento ante un conflicto

El servidor siempre gana.

La aplicación debe informar claramente al usuario, por ejemplo:

> El registro ha sido modificado por otro usuario. Tus cambios no se pueden guardar porque estás trabajando sobre una versión anterior.

Se puede ofrecer la acción:

> Actualizar y descartar mis cambios

Al aceptarla:

1. Se obtiene la versión actual del servidor.
2. Se reemplaza la versión local.
3. Se eliminan los cambios locales pendientes.
4. Se muestra el registro actualizado.

No se realiza una combinación automática de cambios.

## 13. Borrado lógico

Cuando un registro que forma parte de la caché necesita ser eliminado y es importante que el cliente pueda conocer ese borrado, se utiliza:

```text
Eliminado = 1
Version = Version + 1
FechaModificacion = ahora
```

Ejemplo:

```text
Antes:
JugadorId = A123
Version = 17
Eliminado = 0

Después:
JugadorId = A123
Version = 18
Eliminado = 1
```

Las consultas normales no deben mostrar registros eliminados.

## 14. Borrado físico

El borrado físico debe reservarse para casos excepcionales y controlados. Para datos importantes del dominio se recomienda el borrado lógico.

## 15. Persona y jugador

`Persona` representa a cualquier persona relacionada con el sistema: jugador del club, rival externo, miembro de la directiva o usuario.

`Jugador` representa la relación de una persona con el club como jugador.

Una persona puede existir sin ser jugador. Esto permite registrar rivales externos.

Si posteriormente un rival se incorpora al club, se crea su relación `Jugador` sin modificar las partidas históricas.

## 16. Equipos

`Equipo` representa un equipo permanente del club.

La categoría en la que juega un equipo depende de la temporada y se representa mediante `EquipoTemporada`.

Un mismo equipo puede estar en categorías diferentes en distintas temporadas.

## 17. Equipo por temporada

`EquipoTemporada` relaciona:

```text
Equipo
Temporada
Categoría
```

Ejemplo:

```text
Equipo A
Temporada 2025/2026
Primera
```

y posteriormente:

```text
Equipo A
Temporada 2026/2027
Segunda
```

## 18. Pertenencia administrativa del jugador

`JugadorEquipoTemporada` determina el equipo administrativo al que pertenece un jugador durante una temporada.

Un jugador no puede pertenecer simultáneamente a varios equipos durante la misma temporada.

Esta pertenencia administrativa no cambia cuando el jugador participa temporalmente en una categoría superior.

## 19. Temporadas

Una temporada agrupa la actividad deportiva de un periodo, por ejemplo:

```text
2025/2026
2026/2027
```

Los equipos y las competiciones se relacionan con una temporada.

## 20. Categorías

Las categorías tienen un nivel numérico:

```text
Nivel 1 = categoría más alta
Nivel 2 = siguiente
Nivel 3 = siguiente
...
```

Por tanto, un número menor representa una categoría superior.

## 21. Torneos

Un torneo pertenece a una temporada y puede tener una o varias categorías.

Ejemplo:

```text
Liga Gallega
  ├── División de Honor
  ├── Primera
  └── Segunda
```

Cada categoría dentro del torneo se representa mediante `TorneoCategoria`.

## 22. Rondas

Cada `Ronda` pertenece a una `TorneoCategoria`.

Una ronda tiene número, fecha, hora, lugar y observaciones.

## 23. Disponibilidad

Los jugadores pueden indicar si están disponibles para una ronda.

La disponibilidad pertenece a:

```text
Ronda
Jugador
```

La categoría no se duplica en `Disponibilidad`, porque se obtiene a través de la ronda.

## 24. Disponibilidad y participación

Disponibilidad y participación son conceptos diferentes.

Un jugador puede indicar que no está disponible y, excepcionalmente, acabar participando.

Por eso existen entidades separadas:

- `Disponibilidad`: previsión.
- `ParticipacionJugador`: participación real.

La participación no depende obligatoriamente de la disponibilidad.

## 25. Participación del jugador

`ParticipacionJugador` registra que un jugador participa realmente en una ronda.

Permite distinguir entre:

- Equipo administrativo del jugador.
- Equipo que realmente representa en esa participación.

Esta distinción es necesaria para los ascensos.

## 26. Ascensos

Los ascensos son una regla específica de determinados torneos.

`NumeroMaxAscensos` puede ser:

```text
NULL = torneo sin regla de ascensos
0    = no se permiten ascensos
> 0  = número máximo de ascensos
```

## 27. Funcionamiento de los ascensos

El jugador mantiene siempre su equipo administrativo original.

El ascenso es una situación específica del jugador dentro del torneo y la temporada.

Ejemplo:

```text
Equipo administrativo: Equipo B - Segunda
Máximo de ascensos: 3
```

Si participa tres veces en una categoría superior:

```text
Ascenso 1
Ascenso 2
Ascenso 3
```

Al alcanzar el máximo, queda fijado en la categoría superior correspondiente para ese torneo.

Su pertenencia administrativa al equipo original no cambia.

## 28. Situación del jugador en el torneo

`SituacionJugadorTorneo` guarda la situación específica del jugador durante el torneo:

- Equipo de origen.
- Categoría de origen.
- Equipo/categoría actual dentro del torneo.
- Número de ascensos realizados.
- Si el ascenso se ha completado.
- Fecha de fijación.

Esta situación no modifica la pertenencia administrativa del jugador.

## 29. Registro de ascensos

`AscensoJugador` registra cada ascenso individual y conserva la categoría/equipo de origen y destino.

El número de ascenso es único para el jugador dentro del torneo.

## 30. Partidas

Una partida pertenece a una ronda y contiene dos personas:

```text
BlancasPersonaId
NegrasPersonaId
```

Se utilizan personas y no `JugadorId` porque el rival puede ser externo al club.

Esto también permite que dos jugadores del mismo club se enfrenten entre sí.

## 31. Equipos representados en una partida

`PartidaEquipo` permite asociar cada persona de una partida al equipo que representa, cuando sea necesario.

## 32. Resultado de una partida

Los valores previstos son:

```text
1 = ganan blancas
0 = ganan negras
D = tablas
NULL = pendiente
```

También pueden almacenarse Elo, ECO, PGN y observaciones.

## 33. Directiva

La directiva se separa en:

- `CargoDirectivo`: Presidente, Vicepresidente, Secretario, Tesorero, Vocal, etc.
- `MiembroDirectiva`: persona que ocupa un cargo durante un periodo.

Un cargo directivo no equivale a un rol de autorización de la aplicación.

## 34. Usuarios, roles y permisos

La autorización sigue esta estructura:

```text
Usuario
   ↓
UsuarioRol
   ↓
Rol
   ↓
RolPermiso
   ↓
Permiso
```

El rol `Administrador` puede disponer, entre otros, de los permisos necesarios para administrar el blog.

## 35. Cargo directivo frente a rol de aplicación

Ser presidente del club no implica automáticamente ser administrador de la aplicación.

Son conceptos independientes:

```text
Cargo = Presidente
Rol aplicación = Administrador
```

pueden coincidir, pero no tienen por qué hacerlo.

## 36. Blog

El club dispone de un blog.

Los artículos pueden contener:

- Título.
- Resumen.
- Contenido.
- Imagen.
- Publicado/no publicado.
- Fecha de publicación.
- Usuario de alta.
- Usuario de última modificación.

Los artículos pueden pertenecer a una o varias categorías.

## 37. Administración del blog

La edición del blog se controla mediante permisos de aplicación.

El permiso para editar artículos debe estar asociado al rol `Administrador`.

La autorización debe controlarse en la aplicación/API mediante políticas de autorización.

## 38. Documentos del club

`DocumentoClub` permite registrar documentos del club y sus referencias.

Puede contener nombre, descripción, ruta/URL, tipo y fecha.

El contenido físico puede almacenarse fuera de SQL Server y la base de datos guardar su referencia.

## 39. Caché móvil

SQLite almacena los datos necesarios para trabajar sin conexión.

La caché permite:

- Consultar datos offline.
- Modificar datos offline.
- Mantener cambios pendientes.
- Enviar cambios cuando vuelve la conexión.

La caché nunca es la fuente de verdad.

## 40. Caché web

La aplicación web utilizará preferentemente IndexedDB para datos estructurados y trabajo offline.

IndexedDB es preferible a LocalStorage para este escenario por el volumen y la estructura de los datos.

## 41. Estado local de sincronización

Para los registros modificables offline, el cliente debe poder conocer:

```text
Id
VersionServidor
PendienteDeGuardar
```

Ejemplo:

```text
JugadorId = A123
VersionServidor = 15
PendienteDeGuardar = true
```

## 42. Flujo offline completo

### Cargar

```text
Servidor
   ↓
API
   ↓
Aplicación
   ↓
Caché local
```

### Trabajar sin conexión

```text
Usuario
   ↓
Caché local
```

### Recuperar conexión

```text
Caché local
   ↓
API
   ↓
Servidor
```

### Comprobar versión

```text
VersionCliente == VersionServidor
```

Si coincide: guardar.

Si no coincide: conflicto.

## 43. Regla de conflicto

La regla general es:

```text
Si VersionCliente == VersionServidor
    aceptar modificación
si no
    rechazar modificación
    devolver conflicto
```

No se realizan fusiones automáticas y nunca se sobrescriben silenciosamente cambios de otros usuarios.

## 44. Transacciones

Las operaciones que modifiquen varias entidades relacionadas deben realizarse dentro de una transacción.

Por ejemplo, registrar un ascenso puede implicar:

1. Crear `AscensoJugador`.
2. Actualizar `SituacionJugadorTorneo`.
3. Incrementar `AscensosRealizados`.
4. Establecer `AscensoCompletado` si corresponde.

Todas las operaciones deben confirmarse juntas.

## 45. Reglas de integridad importantes

- Una persona solo puede tener una entidad `Jugador`.
- Un equipo solo tiene una categoría por temporada.
- Un jugador solo pertenece administrativamente a un equipo por temporada.
- Una ronda tiene un número único dentro de una categoría de torneo.
- Un jugador solo tiene una disponibilidad por ronda.
- Un jugador solo tiene una participación por ronda.
- Blancas y negras deben ser personas diferentes.
- El número de ascenso es único para un jugador dentro de un torneo.

## 46. Responsabilidad de la API

La API debe ser responsable de las reglas de negocio importantes.

El cliente no debe decidir:

- La versión definitiva.
- Si existe conflicto.
- La nueva versión del registro.
- Si un ascenso es válido.
- Si se ha alcanzado el máximo de ascensos.
- Qué datos prevalecen en un conflicto.

El servidor valida y decide.

## 47. Seguridad

El cliente es un consumidor de la API.

La API debe validar siempre:

- Usuario.
- Permisos.
- Identificadores.
- Relaciones.
- Reglas de negocio.
- Versiones.
- Conflictos.
- Datos de entrada.

Nunca se debe confiar ciegamente en los datos enviados desde móvil o web.

## 48. Resumen de sincronización

```text
                 SQL SERVER
              FUENTE DE VERDAD
                    │
                    │
                  API
                 /   \
                /     \
             MÓVIL     WEB
            SQLite   IndexedDB
```

Cada registro sincronizable contiene:

```text
Id
Version
FechaModificacion
Eliminado
```

El cliente conserva:

```text
Id
VersionServidor
PendienteDeGuardar
```

Al guardar:

```text
Version cliente
       │
       ▼
      API
       │
       ▼
¿Coincide con servidor?
   │             │
  SÍ             NO
   │             │
   ▼             ▼
GUARDAR       CONFLICTO
   │             │
   ▼             ▼
Version++    Servidor gana
```

## 49. Filosofía del diseño

El diseño busca un equilibrio entre robustez y sencillez.

No se pretende crear un sistema de sincronización genérico para grandes volúmenes de datos.

La aplicación es relativamente pequeña y el hecho de que un usuario pueda tener temporalmente datos antiguos en caché no es crítico.

La prioridad es:

1. Poder trabajar offline.
2. Poder guardar posteriormente los cambios.
3. Detectar modificaciones realizadas por otros usuarios.
4. No sobrescribir nunca silenciosamente una modificación ajena.
5. Mantener el servidor como fuente de verdad.
6. Resolver un conflicto de forma sencilla: servidor gana.
7. Evitar una infraestructura de sincronización innecesariamente compleja.

## 50. Decisiones técnicas acordadas

| Aspecto | Decisión |
|---|---|
| Base de datos central | SQL Server |
| Backend | API .NET |
| Aplicación móvil | .NET MAUI + Blazor Hybrid |
| Caché móvil | SQLite |
| Aplicación web | Blazor |
| Caché web | IndexedDB |
| Identificadores | GUID / UNIQUEIDENTIFIER |
| Fuente de verdad | Servidor |
| Control de concurrencia | Version |
| Información de modificación | FechaModificacion |
| Borrado | Preferentemente lógico en datos sincronizados |
| Conflictos | Servidor gana |
| Resolución automática de conflictos | No |
| Sincronización completa automática | No |
| Historial de operaciones de sincronización | No inicialmente |
| SyncChange | No |
| SyncOperation | No |
| Cursores de sincronización | No |
| Trabajo offline | Sí |
| Modificación offline | Sí |
| Guardado condicionado a versión | Sí |
| Incremento de versión | Solo servidor |
