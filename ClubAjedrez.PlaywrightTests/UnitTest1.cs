using Microsoft.Playwright;
using Xunit;

namespace ClubAjedrez.PlaywrightTests;

public class CounterE2ETests
{
    [Fact]
    public async Task Contador_DeberiaIncrementar_AlHacerClicEnElBoton()
    {
        // 1. Inicializar la instancia de Playwright
        using var playwright = await Playwright.CreateAsync();

        // 2. Abrir el navegador (Chromium en modo visible para ver la prueba en tiempo real)
        await using var browser = await playwright.Chromium.LaunchAsync(new BrowserTypeLaunchOptions
        {
            Headless = false, // Pon 'true' si prefieres que se ejecute en segundo plano sin abrir ventana
            SlowMo = 1000       // Pausa de 500ms entre acciones para poder ver qué hace el test
        });

        var context = await browser.NewContextAsync();
        var page = await context.NewPageAsync();

        // 3. Navegar a tu aplicación Blazor Web (¡Ajusta el puerto según tu proyecto!)
        await page.GotoAsync("https://localhost:7233/counter");

        // 4. Hacer clic en el botón "Click me"
        await page.ClickAsync("button.btn-primary");

        // 5. Obtener el texto del elemento <p role="status">
        var statusText = await page.TextContentAsync("p[role='status']");

        // 6. Verificar que el texto muestra "Current count: 1"
        Assert.NotNull(statusText);
        Assert.Contains("Current count: 1", statusText);
    }
}