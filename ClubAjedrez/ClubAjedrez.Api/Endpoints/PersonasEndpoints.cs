using System.ComponentModel.DataAnnotations;
using ClubAjedrez.Api.Data;
using ClubAjedrez.Contracts;
using ClubAjedrez.Contracts.Personas;
using Microsoft.EntityFrameworkCore;

namespace ClubAjedrez.Api.Endpoints;

// CRUD de dbo.Persona.
public static class PersonasEndpoints
{
    public static RouteGroupBuilder MapPersonasEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/personas").WithTags("Personas");

        group.MapGet("/", async (ClubAjedrezDbContext db, CancellationToken ct) =>
            await db.Personas
                .AsNoTracking()
                .OrderBy(p => p.Apellidos).ThenBy(p => p.Nombre)
                .Select(p => p.ToDto())
                .ToListAsync(ct));

        group.MapGet("/{id:guid}", async (Guid id, ClubAjedrezDbContext db, CancellationToken ct) =>
            await db.Personas.AsNoTracking().FirstOrDefaultAsync(p => p.PersonaId == id, ct) is { } persona
                ? Results.Ok(persona.ToDto())
                : Results.NotFound());

        group.MapPost("/", async (PersonaRequest request, ClubAjedrezDbContext db, CancellationToken ct) =>
        {
            if (Validate(request) is { } invalid) return invalid;

            var persona = new Persona();
            persona.Apply(request);
            db.Personas.Add(persona);
            await db.SaveChangesAsync(ct);

            return Results.Created($"/api/personas/{persona.PersonaId}", persona.ToDto());
        });

        group.MapPut("/{id:guid}", async (Guid id, PersonaRequest request, ClubAjedrezDbContext db, CancellationToken ct) =>
        {
            if (Validate(request) is { } invalid) return invalid;

            var persona = await db.Personas.FirstOrDefaultAsync(p => p.PersonaId == id, ct);
            if (persona is null) return Results.NotFound();

            // El servidor gana: si el cliente trabajaba sobre otra versión no se guarda nada
            // y se le devuelve el registro actual.
            if (persona.Version != request.Version) return ModificadoPorOtro(persona);

            persona.Apply(request);
            persona.MarcarModificada();

            try
            {
                // Version es token de concurrencia: el UPDATE lleva "WHERE Version = <leída>",
                // lo que cubre a quien guarde entre la lectura de arriba y este UPDATE.
                await db.SaveChangesAsync(ct);
            }
            catch (DbUpdateConcurrencyException)
            {
                var actual = await db.Personas.AsNoTracking().FirstOrDefaultAsync(p => p.PersonaId == id, ct);
                return actual is null ? Results.NotFound() : ModificadoPorOtro(actual);
            }

            // Se devuelve el registro con su nueva Version para que el cliente actualice su copia.
            return Results.Ok(persona.ToDto());
        });

        group.MapDelete("/{id:guid}", async (Guid id, ClubAjedrezDbContext db, CancellationToken ct) =>
        {
            // Borrado lógico: Persona está referenciada por Jugador, Usuario, Partida, etc.
            var ahora = DateTime.UtcNow;
            var borrados = await db.Personas
                .Where(p => p.PersonaId == id)
                .ExecuteUpdateAsync(s => s
                    .SetProperty(p => p.Eliminado, true)
                    .SetProperty(p => p.FechaModificacion, ahora)
                    .SetProperty(p => p.Version, p => p.Version + 1), ct);

            return borrados == 0 ? Results.NotFound() : Results.NoContent();
        });

        return group;
    }

    private static IResult? Validate(PersonaRequest request)
    {
        var results = new List<ValidationResult>();
        if (Validator.TryValidateObject(request, new ValidationContext(request), results, validateAllProperties: true))
            return null;

        var errors = results
            .SelectMany(r => r.MemberNames.DefaultIfEmpty(string.Empty), (r, member) => (member, r.ErrorMessage ?? "Valor no válido."))
            .GroupBy(e => e.member, e => e.Item2)
            .ToDictionary(g => g.Key, g => g.ToArray());

        return Results.ValidationProblem(errors);
    }

    private static IResult ModificadoPorOtro(Persona actual) =>
        Results.Conflict(new Conflicto<PersonaDto>("La persona ha sido modificada por otro usuario.", actual.ToDto()));
}
