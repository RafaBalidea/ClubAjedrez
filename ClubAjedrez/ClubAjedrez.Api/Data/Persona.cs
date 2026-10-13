using ClubAjedrez.Contracts.Personas;

namespace ClubAjedrez.Api.Data;

// Tabla dbo.Persona: cualquier persona relacionada con el club (jugadores, rivales externos, directiva, usuarios).
public class Persona
{
    public Guid PersonaId { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Apellidos { get; set; } = string.Empty;
    public string? DNI { get; set; }
    public string? Email { get; set; }
    public string? Telefono { get; set; }
    public DateOnly? FechaNacimiento { get; set; }
    public DateTime FechaCreacion { get; set; }
    public DateTime FechaModificacion { get; set; }
    public long Version { get; set; }
    public bool Eliminado { get; set; }

    public PersonaDto ToDto() =>
        new(PersonaId, Nombre, Apellidos, DNI, Email, Telefono, FechaNacimiento, Version);

    public void Apply(PersonaRequest request)
    {
        Nombre = request.Nombre.Trim();
        Apellidos = request.Apellidos.Trim();
        DNI = Normalizar(request.Dni);
        Email = Normalizar(request.Email);
        Telefono = Normalizar(request.Telefono);
        FechaNacimiento = request.FechaNacimiento;
    }

    // La base de datos no tiene triggers: la API mantiene la fecha de modificación y la versión.
    public void MarcarModificada()
    {
        FechaModificacion = DateTime.UtcNow;
        Version++;
    }

    private static string? Normalizar(string? valor) =>
        string.IsNullOrWhiteSpace(valor) ? null : valor.Trim();
}
