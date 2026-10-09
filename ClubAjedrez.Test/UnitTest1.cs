using System.Diagnostics.Metrics;
using Bunit;
using ClubAjedrez.Shared.Pages;
using Xunit;

namespace ClubAjedrez.Tests;

public class CounterTests : BunitContext
{
    [Fact]
    public void Counter_DeberiaIncrementar_AlHacerClic()
    {
        // 1. Renderizar el componente Counter
        var cut = Render<Counter>();

        // 2. Verificar el estado inicial
        cut.Find("p").MarkupMatches("<p role=\"status\">Current count: 0</p>");

        // 3. Simular clic en el botón
        cut.Find("button").Click();

        // 4. Verificar que el contador subió a 1
        cut.Find("p").MarkupMatches("<p role=\"status\">Current count: 1</p>");
    }

    [Fact]
    public void Counter_DeberiaDeIncrementar_AlHacerClic()
    {
        // 1. Renderizar el componente Counter
        var cut = Render<Counter>();

        // 2. Verificar el estado inicial
        cut.Find("p").MarkupMatches("<p role=\"status\">Current count: 0</p>");

        // 3. Simular clic en el botón
        cut.Find("button").Click();

        // 4. Verificar que el contador subió a 1
        cut.Find("p").MarkupMatches("<p role=\"status\">Current count: 0</p>");
    }
}