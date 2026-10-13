using ClubAjedrez.Contracts;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using MudBlazor.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);

// Servicios de MudBlazor (diálogos, snackbar, popovers...) usados por ClubAjedrez.Shared
builder.Services.AddMudServices();

// Cliente Refit de ClubAjedrez.Api (URL base en wwwroot/appsettings.json)
builder.Services.AddClubAjedrezApi(new Uri(builder.Configuration["Api:BaseUrl"]!));

await builder.Build().RunAsync();
