using Microsoft.EntityFrameworkCore;

namespace ClubAjedrez.Api.Data;

// Mapea la base de datos existente clubAjedrez (database-first): el esquema lo gestiona
// la propia base de datos, no las migraciones de EF Core.
public class ClubAjedrezDbContext(DbContextOptions<ClubAjedrezDbContext> options) : DbContext(options)
{
    public DbSet<Persona> Personas => Set<Persona>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Persona>(persona =>
        {
            persona.ToTable("Persona");
            persona.HasKey(p => p.PersonaId);
            persona.Property(p => p.PersonaId).HasDefaultValueSql("newsequentialid()");
            persona.Property(p => p.Nombre).HasMaxLength(100).IsRequired();
            persona.Property(p => p.Apellidos).HasMaxLength(200).IsRequired();
            persona.Property(p => p.DNI).HasMaxLength(20);
            persona.Property(p => p.Email).HasMaxLength(200);
            persona.Property(p => p.Telefono).HasMaxLength(50);
            persona.Property(p => p.FechaCreacion).HasDefaultValueSql("sysutcdatetime()");
            persona.Property(p => p.FechaModificacion).HasDefaultValueSql("sysutcdatetime()");
            persona.Property(p => p.Version).HasDefaultValue(1L).IsConcurrencyToken();
            persona.Property(p => p.Eliminado).HasDefaultValue(false);

            // Borrado lógico: las filas con Eliminado = 1 no se ven en ninguna consulta.
            persona.HasQueryFilter(p => !p.Eliminado);
        });
    }
}
