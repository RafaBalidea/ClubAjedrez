using System.Text.Json;
using System.Text.Json.Serialization;
using ClubAjedrez.Contracts.Personas;

namespace ClubAjedrez.Contracts;

// Serialización JSON generada en compilación para los clientes Refit
// (Refit 16 no usa reflexión). Cada tipo que viaje por la API tiene que estar aquí.
[JsonSourceGenerationOptions(JsonSerializerDefaults.Web)]
[JsonSerializable(typeof(PersonaDto))]
[JsonSerializable(typeof(List<PersonaDto>))]
[JsonSerializable(typeof(PersonaRequest))]
[JsonSerializable(typeof(Conflicto<PersonaDto>))]
[JsonSerializable(typeof(Refit.ProblemDetails))]
public partial class ClubAjedrezJsonContext : JsonSerializerContext;
