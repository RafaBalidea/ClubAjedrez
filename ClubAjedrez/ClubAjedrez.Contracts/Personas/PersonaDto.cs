namespace ClubAjedrez.Contracts.Personas;

// Fila de dbo.Persona. Version se devuelve en PersonaRequest al modificar
// para detectar cambios concurrentes.
public record PersonaDto(
    Guid Id,
    string Nombre,
    string Apellidos,
    string? Dni,
    string? Email,
    string? Telefono,
    DateOnly? FechaNacimiento,
    long Version);
