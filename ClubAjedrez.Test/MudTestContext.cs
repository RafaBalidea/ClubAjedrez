using Bunit;
using MudBlazor.Services;

namespace ClubAjedrez.Tests;

// Contexto de bUnit para componentes que usan MudBlazor: registra sus servicios
// (diálogos, snackbar, popovers...) y deja que sus llamadas a JavaScript no fallen.
// IAsyncLifetime hace que xUnit libere el contexto de forma asíncrona: algunos
// servicios de MudBlazor solo implementan IAsyncDisposable.
public abstract class MudTestContext : BunitContext, IAsyncLifetime
{
    protected MudTestContext()
    {
        JSInterop.Mode = JSRuntimeMode.Loose;
        Services.AddMudServices();
    }

    Task IAsyncLifetime.InitializeAsync() => Task.CompletedTask;

    Task IAsyncLifetime.DisposeAsync() => DisposeAsync().AsTask();
}
