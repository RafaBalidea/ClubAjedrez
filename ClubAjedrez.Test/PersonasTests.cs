using System.Net;
using System.Net.Http.Json;
using Bunit;
using ClubAjedrez.Contracts;
using ClubAjedrez.Contracts.Personas;
using ClubAjedrez.Shared.Pages.Personas;
using Microsoft.AspNetCore.Components;
using Microsoft.Extensions.DependencyInjection;
using MudBlazor;
using NSubstitute;
using NSubstitute.ExceptionExtensions;
using Refit;

namespace ClubAjedrez.Tests;

public class PersonasListTests : MudTestContext
{
    private readonly IPersonasApi api = Substitute.For<IPersonasApi>();

    public PersonasListTests()
    {
        Services.AddSingleton(api);
    }

    [Fact]
    public void PersonasList_DeberiaMostrarUnaFilaPorPersona()
    {
        api.GetAllAsync(Arg.Any<CancellationToken>()).Returns([CrearPersona("Ana"), CrearPersona("Luis")]);

        var cut = Render<PersonasList>();

        cut.WaitForAssertion(() => Assert.Equal(2, cut.FindAll("tbody tr").Count));
        Assert.Contains("García, Ana", cut.Markup);
    }

    [Fact]
    public void PersonasList_DeberiaEliminarLaPersona_AlConfirmarElDialogo()
    {
        var ana = CrearPersona("Ana");
        api.GetAllAsync(Arg.Any<CancellationToken>()).Returns([ana, CrearPersona("Luis")]);
        // El diálogo de confirmación se pinta dentro del MudDialogProvider (en la app está en MainLayout).
        var dialogos = Render<MudDialogProvider>();
        var cut = Render<PersonasList>();
        cut.WaitForAssertion(() => Assert.Equal(2, cut.FindAll("tbody tr").Count));

        cut.FindAll("button[aria-label='Eliminar']")[0].Click();
        dialogos.WaitForAssertion(() => Assert.Contains("¿Eliminar a Ana García?", dialogos.Markup));
        dialogos.FindAll("button").First(b => b.TextContent.Trim() == "Eliminar").Click();

        cut.WaitForAssertion(() => Assert.Single(cut.FindAll("tbody tr")));
        api.Received(1).DeleteAsync(ana.Id, Arg.Any<CancellationToken>());
    }

    [Fact]
    public void PersonasList_NoDeberiaEliminar_SiSeCancelaElDialogo()
    {
        api.GetAllAsync(Arg.Any<CancellationToken>()).Returns([CrearPersona("Ana")]);
        var dialogos = Render<MudDialogProvider>();
        var cut = Render<PersonasList>();
        cut.WaitForAssertion(() => Assert.Single(cut.FindAll("tbody tr")));

        cut.Find("button[aria-label='Eliminar']").Click();
        dialogos.WaitForAssertion(() => dialogos.FindAll("button").First(b => b.TextContent.Trim() == "Cancelar").Click());

        api.DidNotReceiveWithAnyArgs().DeleteAsync(default, default);
        Assert.Single(cut.FindAll("tbody tr"));
    }

    [Fact]
    public void PersonasList_DeberiaMostrarError_SiLaApiNoEstaArrancada()
    {
        // Refit 16 envuelve los errores de conexión en ApiRequestException (no en HttpRequestException).
        var sinConexion = new ApiRequestException(
            new HttpRequestMessage(HttpMethod.Get, "https://localhost:7166/api/personas"), HttpMethod.Get,
            new RefitSettings(), new HttpRequestException("No se puede establecer una conexión"));
        api.GetAllAsync(Arg.Any<CancellationToken>()).ThrowsAsync(sinConexion);

        var cut = Render<PersonasList>();

        cut.WaitForAssertion(() => Assert.Contains("No se pudo cargar la lista de personas.", cut.Find(".mud-alert").TextContent));
    }

    internal static PersonaDto CrearPersona(string nombre, long version = 1) =>
        new(Guid.NewGuid(), nombre, "García", "12345678Z", $"{nombre.ToLower()}@club.es", null, new DateOnly(1990, 5, 1), version);
}

public class PersonaFormTests : MudTestContext
{
    private readonly IPersonasApi api = Substitute.For<IPersonasApi>();

    public PersonaFormTests()
    {
        Services.AddSingleton(api);
    }

    [Fact]
    public void PersonaForm_DeberiaCrearLaPersonaYVolverALaLista_AlGuardar()
    {
        var cut = Render<PersonaForm>();

        cut.Find("#nombre").Change("Ana");
        cut.Find("#apellidos").Change("García");
        cut.Find("#dni").Change("12345678Z");
        cut.Find("form").Submit();

        cut.WaitForAssertion(() => api.Received(1).CreateAsync(
            Arg.Is<PersonaRequest>(s => s.Nombre == "Ana" && s.Dni == "12345678Z"),
            Arg.Any<CancellationToken>()));
        var navigation = Services.GetRequiredService<NavigationManager>();
        Assert.EndsWith("/personas", navigation.Uri);
    }

    [Fact]
    public void PersonaForm_NoDeberiaLlamarALaApi_SiFaltanCamposObligatorios()
    {
        var cut = Render<PersonaForm>();

        cut.Find("form").Submit();

        api.DidNotReceiveWithAnyArgs().CreateAsync(default!, default);
        cut.WaitForAssertion(() => Assert.Contains("El nombre es obligatorio.", cut.Markup));
    }

    [Fact]
    public void PersonaForm_DeberiaEnviarLaVersionLeida_AlEditar()
    {
        var ana = PersonasListTests.CrearPersona("Ana", version: 7);
        api.GetByIdAsync(ana.Id, Arg.Any<CancellationToken>()).Returns(ana);
        var cut = Render<PersonaForm>(p => p.Add(f => f.Id, ana.Id));
        cut.WaitForAssertion(() => Assert.Equal("Ana", cut.Find("#nombre").GetAttribute("value")));

        cut.Find("#nombre").Change("Ana María");
        cut.Find("form").Submit();

        cut.WaitForAssertion(() => api.Received(1).UpdateAsync(
            ana.Id,
            Arg.Is<PersonaRequest>(s => s.Nombre == "Ana María" && s.Version == 7),
            Arg.Any<CancellationToken>()));
    }

    [Fact]
    public async Task PersonaForm_DeberiaCargarLaVersionDelServidor_AlActualizarYDescartar()
    {
        var mia = PersonasListTests.CrearPersona("Ana", version: 1);
        var delServidor = mia with { Nombre = "Ana (editada por otro)", Telefono = "611111111", Version = 2 };
        api.GetByIdAsync(mia.Id, Arg.Any<CancellationToken>()).Returns(mia);
        api.UpdateAsync(mia.Id, Arg.Any<PersonaRequest>(), Arg.Any<CancellationToken>())
            .ThrowsAsync(await CrearConflictoAsync(mia.Id, new Conflicto<PersonaDto>("Modificada por otro usuario.", delServidor)));
        var cut = Render<PersonaForm>(p => p.Add(f => f.Id, mia.Id));
        cut.WaitForAssertion(() => cut.Find("form"));

        cut.Find("#nombre").Change("Mis cambios");
        cut.Find("form").Submit();

        cut.WaitForAssertion(() => Assert.Contains("modificada por otro usuario", cut.Find(".mud-alert").TextContent));
        Assert.True(BotonGuardar(cut).HasAttribute("disabled"));

        Boton(cut, "Actualizar y descartar mis cambios").Click();

        cut.WaitForAssertion(() => Assert.Equal("Ana (editada por otro)", cut.Find("#nombre").GetAttribute("value")));
        Assert.Equal("611111111", cut.Find("#telefono").GetAttribute("value"));
        Assert.Empty(cut.FindAll(".mud-alert"));
        Assert.False(BotonGuardar(cut).HasAttribute("disabled"));
        // Usa la versión que venía en el 409, sin volver a pedirla.
        await api.Received(1).GetByIdAsync(mia.Id, Arg.Any<CancellationToken>());

        // Al volver a guardar se envía la versión del servidor.
        api.UpdateAsync(mia.Id, Arg.Any<PersonaRequest>(), Arg.Any<CancellationToken>()).Returns(delServidor with { Version = 3 });
        cut.Find("form").Submit();
        cut.WaitForAssertion(() => api.Received(1).UpdateAsync(mia.Id, Arg.Is<PersonaRequest>(s => s.Version == 2), Arg.Any<CancellationToken>()));
    }

    [Fact]
    public async Task PersonaForm_DeberiaPedirLaVersionAlServidor_SiEl409NoTraeElRegistro()
    {
        var mia = PersonasListTests.CrearPersona("Ana", version: 1);
        var delServidor = mia with { Nombre = "Ana (editada por otro)", Version = 2 };
        api.GetByIdAsync(mia.Id, Arg.Any<CancellationToken>()).Returns(mia, delServidor);
        api.UpdateAsync(mia.Id, Arg.Any<PersonaRequest>(), Arg.Any<CancellationToken>())
            .ThrowsAsync(await CrearConflictoAsync(mia.Id, cuerpo: null));
        var cut = Render<PersonaForm>(p => p.Add(f => f.Id, mia.Id));
        cut.WaitForAssertion(() => cut.Find("form"));
        cut.Find("form").Submit();
        cut.WaitForAssertion(() => cut.Find(".mud-alert"));

        Boton(cut, "Actualizar y descartar mis cambios").Click();

        cut.WaitForAssertion(() => Assert.Equal("Ana (editada por otro)", cut.Find("#nombre").GetAttribute("value")));
        await api.Received(2).GetByIdAsync(mia.Id, Arg.Any<CancellationToken>());
    }

    // 409 como lo genera Refit, con el cuerpo serializado con el mismo contexto JSON que usa la app.
    private static async Task<ApiException> CrearConflictoAsync(Guid id, Conflicto<PersonaDto>? cuerpo)
    {
        var respuesta = new HttpResponseMessage(HttpStatusCode.Conflict);
        if (cuerpo is not null)
            respuesta.Content = JsonContent.Create(cuerpo, ClubAjedrezJsonContext.Default.ConflictoPersonaDto);
        var ajustes = new RefitSettings(new SystemTextJsonContentSerializer(ClubAjedrezJsonContext.Default.Options));
        return await ApiException.Create(
            new HttpRequestMessage(HttpMethod.Put, $"http://localhost/api/personas/{id}"), HttpMethod.Put, respuesta, ajustes);
    }

    private static AngleSharp.Dom.IElement Boton(IRenderedComponent<PersonaForm> cut, string texto) =>
        cut.FindAll("button").Single(b => b.TextContent.Trim() == texto);

    private static AngleSharp.Dom.IElement BotonGuardar(IRenderedComponent<PersonaForm> cut) => Boton(cut, "Guardar");
}
