using System.ComponentModel.DataAnnotations;

namespace ClubAjedrez.Contracts.Personas;

// Se usa tanto para crear como para modificar una persona.
// Las validaciones se comprueban en el formulario (DataAnnotationsValidator) y en la API,
// y las longitudes coinciden con las columnas de dbo.Persona.
public class PersonaRequest
{
    [Required(ErrorMessage = "El nombre es obligatorio.")]
    [StringLength(100, ErrorMessage = "El nombre no puede superar los 100 caracteres.")]
    public string Nombre { get; set; } = string.Empty;

    [Required(ErrorMessage = "Los apellidos son obligatorios.")]
    [StringLength(200, ErrorMessage = "Los apellidos no pueden superar los 200 caracteres.")]
    public string Apellidos { get; set; } = string.Empty;

    [StringLength(20, ErrorMessage = "El DNI no puede superar los 20 caracteres.")]
    public string? Dni { get; set; }

    [EmailAddress(ErrorMessage = "El email no es válido.")]
    [StringLength(200, ErrorMessage = "El email no puede superar los 200 caracteres.")]
    public string? Email { get; set; }

    [Phone(ErrorMessage = "El teléfono no es válido.")]
    [StringLength(50, ErrorMessage = "El teléfono no puede superar los 50 caracteres.")]
    public string? Telefono { get; set; }

    public DateOnly? FechaNacimiento { get; set; }

    // Versión leída de la persona; solo se usa al modificar.
    public long Version { get; set; }

    public static PersonaRequest FromDto(PersonaDto persona) => new()
    {
        Nombre = persona.Nombre,
        Apellidos = persona.Apellidos,
        Dni = persona.Dni,
        Email = persona.Email,
        Telefono = persona.Telefono,
        FechaNacimiento = persona.FechaNacimiento,
        Version = persona.Version,
    };
}
