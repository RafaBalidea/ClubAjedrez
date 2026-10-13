using Microsoft.Playwright;
using static Microsoft.Playwright.Assertions;

namespace ClubAjedrez.PlaywrightTests;

// CRUD de personas de punta a punta: navegador → Web → API → SQL Server.
public class PersonasE2ETests(E2EFixture app) : IClassFixture<E2EFixture>
{
    [Fact]
    public async Task Inicio_DeberiaMostrarElClubYLlevarAPersonas()
    {
        var pagina = await app.AbrirAsync("/");

        await Expect(pagina.GetByRole(AriaRole.Heading, new() { Name = "Club Xadrez Algalia", Level = 1 })).ToBeVisibleAsync();
        await pagina.GetByRole(AriaRole.Link, new() { Name = "Ver personas" }).ClickAsync();

        await Expect(pagina).ToHaveURLAsync(app.WebUrl + "/personas");
        await Expect(pagina.GetByRole(AriaRole.Heading, new() { Name = "Personas", Level = 1 })).ToBeVisibleAsync();
    }

    [Fact]
    public async Task CrearPersona_DeberiaGuardarlaYMostrarlaEnLaLista()
    {
        var nombre = E2EFixture.NombreUnico("Nueva");
        var pagina = await app.AbrirAsync("/personas");

        await pagina.GetByRole(AriaRole.Link, new() { Name = "Nueva persona" }).ClickAsync();
        await RellenarAsync(pagina, "#nombre", nombre);
        await RellenarAsync(pagina, "#apellidos", "Prueba E2E");
        await RellenarAsync(pagina, "#email", E2EFixture.EmailUnico());
        await pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" }).ClickAsync();

        await Expect(pagina).ToHaveURLAsync(app.WebUrl + "/personas");
        await Expect(Fila(pagina, nombre)).ToBeVisibleAsync();
    }

    [Fact]
    public async Task CrearPersona_NoDeberiaGuardar_SiFaltanCamposObligatorios()
    {
        var pagina = await app.AbrirAsync("/personas/nueva");

        await pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" }).ClickAsync();

        await Expect(pagina.GetByText("El nombre es obligatorio.")).ToBeVisibleAsync();
        await Expect(pagina.GetByText("Los apellidos son obligatorios.")).ToBeVisibleAsync();
        await Expect(pagina).ToHaveURLAsync(app.WebUrl + "/personas/nueva");
    }

    [Fact]
    public async Task EditarPersona_DeberiaGuardarLosCambios()
    {
        var persona = await app.CrearPersonaAsync(E2EFixture.NombreUnico("Editar"));
        var nuevoNombre = E2EFixture.NombreUnico("Editada");
        var pagina = await app.AbrirAsync($"/personas/{persona.GetProperty("id").GetString()}");
        await Expect(pagina.Locator("#nombre")).ToHaveValueAsync(persona.GetProperty("nombre").GetString()!);

        await RellenarAsync(pagina, "#nombre", nuevoNombre);
        await pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" }).ClickAsync();

        await Expect(pagina).ToHaveURLAsync(app.WebUrl + "/personas");
        await Expect(Fila(pagina, nuevoNombre)).ToBeVisibleAsync();
    }

    [Fact]
    public async Task EliminarPersona_DeberiaQuitarlaDeLaLista_AlConfirmar()
    {
        var nombre = E2EFixture.NombreUnico("Eliminar");
        await app.CrearPersonaAsync(nombre);
        var pagina = await app.AbrirAsync("/personas");
        await Expect(Fila(pagina, nombre)).ToBeVisibleAsync();

        await Fila(pagina, nombre).GetByRole(AriaRole.Button, new() { Name = "Eliminar" }).ClickAsync();
        var dialogo = pagina.Locator(".mud-dialog");
        await Expect(dialogo).ToContainTextAsync($"¿Eliminar a {nombre}");
        await dialogo.GetByRole(AriaRole.Button, new() { Name = "Eliminar" }).ClickAsync();

        await Expect(Fila(pagina, nombre)).ToHaveCountAsync(0);
        // Tras recargar sigue sin aparecer: el borrado lógico se guardó en el servidor.
        await pagina.ReloadAsync();
        await pagina.Locator("[data-interactive='true']").WaitForAsync();
        await Expect(Fila(pagina, nombre)).ToHaveCountAsync(0);
    }

    [Fact]
    public async Task EditarPersona_DeberiaOfrecerActualizarYDescartar_SiOtroUsuarioLaModifico()
    {
        var persona = await app.CrearPersonaAsync(E2EFixture.NombreUnico("Conflicto"));
        var id = persona.GetProperty("id").GetString();
        var pagina = await app.AbrirAsync($"/personas/{id}");
        await Expect(pagina.Locator("#nombre")).ToHaveValueAsync(persona.GetProperty("nombre").GetString()!);

        // Otro usuario guarda antes (versión 1 → 2) directamente en la API.
        var nombreDelOtro = E2EFixture.NombreUnico("DelOtro");
        var respuesta = await app.Api.PutAsync($"/api/personas/{id}", new()
        {
            DataObject = new
            {
                nombre = nombreDelOtro,
                apellidos = persona.GetProperty("apellidos").GetString(),
                email = persona.GetProperty("email").GetString(),
                version = persona.GetProperty("version").GetInt64(),
            },
        });
        Assert.Equal(200, respuesta.Status);

        // Este usuario sigue trabajando sobre la versión 1.
        await RellenarAsync(pagina, "#nombre", "Mis cambios");
        await pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" }).ClickAsync();

        await Expect(pagina.GetByText("ha sido modificada por otro usuario")).ToBeVisibleAsync();
        await Expect(pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" })).ToBeDisabledAsync();

        await pagina.GetByRole(AriaRole.Button, new() { Name = "Actualizar y descartar mis cambios" }).ClickAsync();

        await Expect(pagina.Locator("#nombre")).ToHaveValueAsync(nombreDelOtro);
        await Expect(pagina.GetByRole(AriaRole.Button, new() { Name = "Guardar" })).ToBeEnabledAsync();
    }

    // MudTextField actualiza el valor en el evento change: se rellena y se sale del campo.
    private static async Task RellenarAsync(IPage pagina, string selector, string valor)
    {
        await pagina.Locator(selector).FillAsync(valor);
        await pagina.Locator(selector).PressAsync("Tab");
    }

    private static ILocator Fila(IPage pagina, string texto) =>
        pagina.GetByRole(AriaRole.Row).Filter(new() { HasText = texto });
}
