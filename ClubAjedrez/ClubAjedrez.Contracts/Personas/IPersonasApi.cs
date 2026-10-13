using Refit;

namespace ClubAjedrez.Contracts.Personas;

// Cliente Refit de los endpoints /api/personas de ClubAjedrez.Api.
// Las respuestas con error lanzan Refit.ApiException: 404 si la persona no existe,
// 409 en UpdateAsync si otro usuario la ha modificado antes; el cuerpo es un
// Conflicto<PersonaDto> con el registro actual del servidor.
public interface IPersonasApi
{
    [Get("/api/personas")]
    Task<List<PersonaDto>> GetAllAsync(CancellationToken cancellationToken = default);

    [Get("/api/personas/{id}")]
    Task<PersonaDto> GetByIdAsync(Guid id, CancellationToken cancellationToken = default);

    [Post("/api/personas")]
    Task<PersonaDto> CreateAsync([Body] PersonaRequest persona, CancellationToken cancellationToken = default);

    [Put("/api/personas/{id}")]
    Task<PersonaDto> UpdateAsync(Guid id, [Body] PersonaRequest persona, CancellationToken cancellationToken = default);

    [Delete("/api/personas/{id}")]
    Task DeleteAsync(Guid id, CancellationToken cancellationToken = default);
}
