using ClubAjedrez.Contracts;
using ClubAjedrez.Web.Components;
using MudBlazor.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents()
    .AddInteractiveWebAssemblyComponents();

// Servicios de MudBlazor (diálogos, snackbar, popovers...) usados por ClubAjedrez.Shared
builder.Services.AddMudServices();

// Cliente Refit de ClubAjedrez.Api (se usa al prerenderizar y en modo Server)
builder.Services.AddClubAjedrezApi(new Uri(builder.Configuration["Api:BaseUrl"]!));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseWebAssemblyDebugging();
}
else
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}
app.UseStatusCodePagesWithReExecute("/not-found", createScopeForStatusCodePages: true);
app.UseHttpsRedirection();

app.UseAntiforgery();

app.MapStaticAssets();

app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode()
    .AddInteractiveWebAssemblyRenderMode()
    .AddAdditionalAssemblies(
        typeof(ClubAjedrez.Shared._Imports).Assembly,
        typeof(ClubAjedrez.Web.Client._Imports).Assembly);

app.Run();
