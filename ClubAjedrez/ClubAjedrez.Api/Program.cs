using ClubAjedrez.Api.Data;
using ClubAjedrez.Api.Endpoints;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddProblemDetails();

builder.Services.AddDbContext<ClubAjedrezDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("ClubAjedrez")));

// El cliente WebAssembly llama a la API desde el navegador, con otro origen.
// MAUI y el prerenderizado del servidor no necesitan CORS.
var corsOrigins = builder.Configuration.GetSection("Cors:Origins").Get<string[]>() ?? [];
builder.Services.AddCors(options =>
    options.AddDefaultPolicy(policy => policy
        .WithOrigins(corsOrigins)
        .AllowAnyHeader()
        .AllowAnyMethod()));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseCors();

app.MapPersonasEndpoints();

app.Run();
