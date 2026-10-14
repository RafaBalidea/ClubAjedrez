# ClubAjedrez Constitution

## Core Principles

### I. Desarrollo guiado por pruebas — TDD (NO NEGOCIABLE)

Todo código de producción nace de un test que falla. El ciclo Rojo → Verde → Refactor es
obligatorio y se aplica a la API, a los contratos y a la UI.

- Ninguna línea de código de producción se escribe sin un test automatizado previo que falle
  por el motivo esperado (Rojo). Se escribe el mínimo código que lo hace pasar (Verde) y después
  se refactoriza con todos los tests en verde (Refactor).
- El test fallido DEBE ejecutarse y verse fallar antes de implementar; un test que pasa a la
  primera no demuestra nada y DEBE revisarse.
- Cada corrección de un bug empieza por un test que reproduce el bug.
- Niveles obligatorios:
  - **Componentes y páginas** (`ClubAjedrez.Shared`): tests bUnit en `ClubAjedrez.Test`,
    heredando `MudTestContext` y con los clientes Refit sustituidos por mocks de NSubstitute.
  - **API y reglas de negocio** (`ClubAjedrez.Api`): tests automatizados de los endpoints y de
    las reglas (versiones, conflicto 409, borrado lógico, validación, permisos, transacciones).
  - **Flujos de usuario**: tests E2E con Playwright en `ClubAjedrez.PlaywrightTests`
    (navegador → Web → API → SQL Server). Toda página o funcionalidad los necesita además de
    los tests bUnit.
- En `tasks.md` las tareas de test de cada historia van antes que sus tareas de
  implementación. Los tests NO son opcionales, aunque la plantilla de tareas lo diga.
- Nombres de los tests en español, describiendo el comportamiento
  (`PersonasList_DeberiaMostrarUnaFilaPorPersona`).

**Razón**: la app sincroniza datos offline con reglas de concurrencia y de dominio fáciles de
romper; solo una red de tests escrita antes del código garantiza que cada regla existe y sigue
funcionando.

### II. Desarrollo guiado por comportamiento — BDD (NO NEGOCIABLE)

El comportamiento se define, se acuerda y se verifica en el lenguaje del club antes de
diseñar o programar.

- Cada historia de usuario de `spec.md` DEBE tener escenarios de aceptación en formato
  **Dado / Cuando / Entonces** (Given/When/Then), escritos en español y con el vocabulario del
  dominio y del esquema (Persona, Jugador, Torneo, Ascenso…).
- Los escenarios describen comportamiento observable por el usuario o por un cliente de la
  API, nunca detalles de implementación (clases, componentes, tablas internas).
- Cada escenario de aceptación DEBE tener al menos un test automatizado que lo verifique
  (Playwright E2E para flujos de UI; test de API para reglas de servidor; bUnit cuando el
  comportamiento es de un componente). El nombre o un comentario del test referencia la
  historia y el escenario (p. ej. `// US1-E2`).
- Los casos límite y los errores (conflicto 409, API no disponible, validación) son escenarios
  de primera clase, no notas al margen.
- El flujo BDD manda sobre el TDD: escenario acordado → test de aceptación en rojo → ciclo TDD
  de las piezas internas → escenario en verde.
- Una historia no está terminada hasta que todos sus escenarios pasan de forma automatizada.

**Razón**: el diseño funcional (`readme.md`) tiene reglas sutiles (ascensos, disponibilidad
frente a participación, servidor gana); los escenarios Dado/Cuando/Entonces las convierten en
ejemplos verificables y evitan malentendidos antes de escribir código.

### III. El servidor es la fuente de la verdad

- La UI nunca accede a la base de datos: todo CRUD pasa por `ClubAjedrez.Api`, consumida con
  Refit a través de los contratos de `ClubAjedrez.Contracts`.
- La API es dueña de las reglas de negocio (versiones, conflictos, ascensos, máximo de
  ascensos) y DEBE validar usuario, permisos, ids y relaciones. Nunca se confía en datos del
  cliente.
- Concurrencia optimista con `Version`: solo el servidor la incrementa; una versión distinta
  devuelve **409** con `Conflicto<T>` (`Mensaje` + `Actual`). En conflicto gana el servidor y
  la UI ofrece "Actualizar y descartar mis cambios". **Nunca se fusionan cambios.**
- Borrado lógico (`Eliminado = 1`) con filtro global; las operaciones que afectan a varias
  entidades se ejecutan en una sola transacción.
- La autorización (`Usuario → UsuarioRol → Rol → RolPermiso → Permiso`) se aplica con
  políticas en la API. Un `CargoDirectivo` no es un rol de aplicación.

**Razón**: con clientes offline (SQLite, IndexedDB) solo un servidor autoritativo y sin
fusiones mantiene los datos coherentes.

### IV. Base de datos propiedad del usuario (database-first)

- El esquema de SQL Server lo define el usuario. No hay migraciones de EF Core y la API nunca
  crea ni altera tablas; las entidades se mapean a mano en `ClubAjedrezDbContext`.
- Todo cambio de esquema es un script SQL numerado en `Database/Migrations/`, confirmado junto
  con los cambios de API correspondientes. Un script ya aplicado nunca se edita: se escribe
  uno nuevo. Nunca se cambia el esquema a mano sin script.
- Toda tabla nueva sigue las convenciones: `<Tabla>Id uniqueidentifier` con
  `newsequentialid()`, `FechaCreacion`/`FechaModificacion` en UTC, `Version bigint`,
  `Eliminado bit`, y restricciones con nombre explícito (`DF_`, `FK_`, `UQ_`, `CK_`).
- Los datos de referencia van en scripts idempotentes separados de los cambios de esquema.

**Razón**: el esquema evoluciona y debe poder recrearse y auditarse; los scripts versionados
son la única fuente fiable de su historia.

### V. UI compartida y multiplataforma

- Páginas y componentes viven en `ClubAjedrez.Shared` para que los usen la web y la app MAUI.
- Toda la UI usa MudBlazor; no se reintroduce Bootstrap ni se mezclan frameworks.
- Los componentes DEBEN funcionar con `InteractiveAuto` (Server y WebAssembly) y en MAUI. Un
  servicio específico de plataforma se define como interfaz en `ClubAjedrez.Shared/Services`
  y se registra en los tres hosts.
- Todo tipo que viaja por una interfaz Refit se añade a `ClubAjedrezJsonContext`.
- Debe funcionar offline: sin dependencias de CDN ni fuentes externas en tiempo de ejecución.

**Razón**: una sola UI para todas las plataformas solo es sostenible si ningún componente
depende de un host concreto.

### VI. Simplicidad y nombres del esquema

- Entidades, endpoints, contratos, páginas y rutas se nombran como la tabla
  (`Persona` → `/api/personas`, `PersonaDto`, `IPersonasApi`, `/personas`). No se inventan
  términos de dominio que no existan en el esquema.
- YAGNI: no se añade infraestructura genérica (p. ej. motores de sincronización, `SyncChange`,
  cursores) ni abstracciones sin una necesidad presente. Toda complejidad adicional DEBE
  justificarse en la sección "Complexity Tracking" del plan.

**Razón**: un vocabulario único entre base de datos, código y escenarios BDD reduce errores de
traducción; la simplicidad mantiene el proyecto abarcable.

## Restricciones técnicas

- **Plataforma**: .NET 10; solución `ClubAjedrez.slnx` (MAUI Blazor Hybrid + Blazor Web App).
- **UI**: MudBlazor 9.x; paquetes `Microsoft.AspNetCore.Components.*` en la misma versión de
  parche en Shared, Web y Web.Client.
- **API**: ASP.NET Core minimal API + EF Core sobre SQL Server; validación con DataAnnotations
  del tipo de petición, devolviendo `ValidationProblem` (400).
- **Cliente HTTP**: Refit 16 con clientes generados (`AddRefitGeneratedClient`) y contexto JSON
  generado; las páginas capturan `ApiExceptionBase` y muestran el error.
- **Tests**: xUnit + bUnit + NSubstitute (componentes), Playwright (E2E) y tests automatizados
  de la API. Los datos de E2E usan emails `@e2e.test` y se limpian antes y después de cada
  ejecución; nunca quedan filas de test en la base de datos de desarrollo.
- **Idioma**: especificaciones, escenarios BDD, comentarios y nombres de tests en español.

## Flujo de desarrollo y puertas de calidad

1. **Especificar** (`/speckit-specify`, `/speckit-clarify`): historias con escenarios
   Dado/Cuando/Entonces completos, incluidos errores y casos límite.
2. **Planificar** (`/speckit-plan`): el "Constitution Check" DEBE confirmar que cada escenario
   tiene asignado su nivel de test (bUnit, API, Playwright) y que se respetan los principios
   III–VI.
3. **Tareas** (`/speckit-tasks`): por cada historia, primero las tareas de test (aceptación y
   unitarios), después la implementación. Una lista de tareas sin tests no es válida.
4. **Implementar** (`/speckit-implement`): BDD + TDD estricto. Se escribe el test, se ejecuta
   y se ve fallar, se implementa, se ve pasar y se refactoriza.
5. **Puertas antes de dar por terminada una historia o hacer merge**:
   - `dotnet build` del lado web sin errores.
   - `dotnet test ClubAjedrez.Test/ClubAjedrez.Tests.csproj` en verde.
   - Tests de la API en verde.
   - `dotnet test ClubAjedrez.PlaywrightTests` en verde con la API y la web arrancadas.
   - Todos los escenarios de aceptación de la historia cubiertos por tests automatizados.
   - Si cambia el esquema: script nuevo en `Database/Migrations/` y mapeo actualizado.
6. Ningún test se desactiva, se salta ni se borra para conseguir el verde sin una
   justificación explícita en la revisión.

## Governance

- Esta constitución prevalece sobre cualquier otra práctica del proyecto. `CLAUDE.md` y
  `readme.md` son la guía de desarrollo y el diseño funcional en tiempo de ejecución; si
  contradicen esta constitución, se corrige el documento o se enmienda la constitución.
- **Enmiendas**: se proponen con `/speckit-constitution`, documentando el cambio y su motivo
  en el Sync Impact Report, y se confirman en un commit propio. Si la enmienda afecta al
  código existente, se incluye un plan de migración.
- **Versionado** (semántico):
  - MAJOR: eliminación o redefinición incompatible de un principio.
  - MINOR: principio o sección nuevos, o ampliación material de una guía.
  - PATCH: aclaraciones, redacción o erratas.
- **Cumplimiento**: cada plan pasa el "Constitution Check" y cada revisión de código verifica
  BDD (escenarios cubiertos) y TDD (tests escritos antes y en verde). Cualquier excepción se
  justifica por escrito en "Complexity Tracking" del plan.

**Version**: 1.0.0 | **Ratified**: 2026-10-14 | **Last Amended**: 2026-10-14
