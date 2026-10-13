using System.Text.Json;
using Microsoft.Data.SqlClient;
using Microsoft.Playwright;

namespace ClubAjedrez.PlaywrightTests;

// Recursos compartidos por los tests E2E: navegador, cliente HTTP contra la API y limpieza de datos.
// Requiere ClubAjedrez.Api y ClubAjedrez.Web arrancados (perfil https). Se configura con variables de entorno:
//   E2E_WEB_URL  (por defecto https://localhost:7233)
//   E2E_API_URL  (por defecto https://localhost:7166)
//   E2E_DB       cadena de conexión para borrar los datos de prueba (por defecto ULPT0176/clubAjedrez)
//   E2E_HEADED=1 para ver el navegador (con pausas entre acciones)
public sealed class E2EFixture : IAsyncLifetime
{
    // Todo lo que crean los tests lleva este dominio de email; se borra físicamente al terminar.
    public const string DominioPruebas = "@e2e.test";

    public string WebUrl { get; } = Variable("E2E_WEB_URL", "https://localhost:7233");
    public string ApiUrl { get; } = Variable("E2E_API_URL", "https://localhost:7166");
    private readonly string conexionBd = Variable("E2E_DB",
        "Server=ULPT0176;Database=clubAjedrez;Trusted_Connection=True;TrustServerCertificate=True");

    private IPlaywright playwright = null!;
    public IBrowser Navegador { get; private set; } = null!;
    public IAPIRequestContext Api { get; private set; } = null!;

    public async Task InitializeAsync()
    {
        await BorrarDatosDePruebaAsync();

        playwright = await Playwright.CreateAsync();
        var conVentana = Environment.GetEnvironmentVariable("E2E_HEADED") == "1";
        Navegador = await playwright.Chromium.LaunchAsync(new()
        {
            Headless = !conVentana,
            SlowMo = conVentana ? 500 : 0,
        });
        Api = await playwright.APIRequest.NewContextAsync(new()
        {
            BaseURL = ApiUrl,
            IgnoreHTTPSErrors = true,
        });
    }

    public async Task DisposeAsync()
    {
        await Api.DisposeAsync();
        await Navegador.DisposeAsync();
        playwright.Dispose();
        await BorrarDatosDePruebaAsync();
    }

    // Abre una página nueva y espera a que Blazor sea interactivo (si no, los clics sobre
    // el HTML prerenderizado se pierden). MainLayout pinta data-interactive="true".
    public async Task<IPage> AbrirAsync(string ruta)
    {
        var contexto = await Navegador.NewContextAsync(new() { BaseURL = WebUrl, IgnoreHTTPSErrors = true });
        var pagina = await contexto.NewPageAsync();
        await pagina.GotoAsync(ruta);
        await pagina.Locator("[data-interactive='true']").WaitForAsync();
        return pagina;
    }

    // Crea una persona directamente en la API (para preparar los tests) y devuelve su JSON.
    public async Task<JsonElement> CrearPersonaAsync(string nombre, string apellidos = "Prueba E2E")
    {
        var respuesta = await Api.PostAsync("/api/personas", new()
        {
            DataObject = new { nombre, apellidos, email = EmailUnico() },
        });
        Assert.Equal(201, respuesta.Status);
        return (await respuesta.JsonAsync())!.Value;
    }

    public static string EmailUnico() => $"{Guid.NewGuid():N}{DominioPruebas}";

    public static string NombreUnico(string prefijo) => $"{prefijo} {Guid.NewGuid().ToString("N")[..8]}";

    private async Task BorrarDatosDePruebaAsync()
    {
        await using var conexion = new SqlConnection(conexionBd);
        await conexion.OpenAsync();
        await using var comando = new SqlCommand("DELETE FROM dbo.Persona WHERE Email LIKE @patron", conexion);
        comando.Parameters.AddWithValue("@patron", "%" + DominioPruebas);
        await comando.ExecuteNonQueryAsync();
    }

    private static string Variable(string nombre, string porDefecto) =>
        Environment.GetEnvironmentVariable(nombre) is { Length: > 0 } valor ? valor : porDefecto;
}
