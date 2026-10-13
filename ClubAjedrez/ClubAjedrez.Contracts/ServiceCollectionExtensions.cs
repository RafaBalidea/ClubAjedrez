using ClubAjedrez.Contracts.Personas;
using Microsoft.Extensions.DependencyInjection;
using Refit;

namespace ClubAjedrez.Contracts;

public static class ServiceCollectionExtensions
{
    // Registra los clientes Refit de ClubAjedrez.Api. Cada host (Web, Web.Client, MAUI)
    // lo llama con su propia URL base.
    public static IServiceCollection AddClubAjedrezApi(this IServiceCollection services, Uri baseAddress)
    {
        services.AddRefitGeneratedClient<IPersonasApi>(ClubAjedrezJsonContext.Default)
            .ConfigureHttpClient(c => c.BaseAddress = baseAddress);

        return services;
    }
}
