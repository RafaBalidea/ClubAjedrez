# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

ClubAjedrez is the management app for the chess club **Club Xadrez Algalia** (name shown in the app bar and on the home page). It is a .NET 10 **.NET MAUI Blazor Hybrid + Blazor Web App** solution (from the `maui-blazor-web` template). The same Razor UI is served both as a web app and as a native app (Android, iOS, MacCatalyst, Windows). Solution file: `ClubAjedrez.slnx` (new XML solution format). Code comments and test names are written in Spanish.

## Commands

Run from the repository root.

```bash
# Build the web side (fast; avoids building the MAUI multi-targeted project)
dotnet build ClubAjedrez/ClubAjedrez.Web/ClubAjedrez.Web.csproj

# Run the data API first (https → https://localhost:7166, http → http://localhost:5207)
dotnet run --project ClubAjedrez/ClubAjedrez.Api --launch-profile https

# Run the web app (https profile → https://localhost:7233, http → http://localhost:5236)
dotnet run --project ClubAjedrez/ClubAjedrez.Web --launch-profile https

# Inspect the database schema (Windows auth)
sqlcmd -S ULPT0176 -E -C -d clubAjedrez -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"

# Build/run the MAUI app for Windows
dotnet build ClubAjedrez/ClubAjedrez/ClubAjedrez.csproj -f net10.0-windows10.0.19041.0
dotnet run --project ClubAjedrez/ClubAjedrez -f net10.0-windows10.0.19041.0

# Unit tests (bUnit component tests)
dotnet test ClubAjedrez.Test/ClubAjedrez.Tests.csproj

# Single test
dotnet test ClubAjedrez.Test/ClubAjedrez.Tests.csproj --filter "FullyQualifiedName~PersonasListTests.PersonasList_DeberiaMostrarUnaFilaPorPersona"

# E2E tests (Playwright): the API and the web app must already be running (https profiles).
# Headless by default; set E2E_HEADED=1 to watch the browser.
dotnet build ClubAjedrez.PlaywrightTests
pwsh ClubAjedrez.PlaywrightTests/bin/Debug/net10.0/playwright.ps1 install   # first time only
dotnet test ClubAjedrez.PlaywrightTests
```

Building the whole solution (`dotnet build ClubAjedrez.slnx`) also builds the MAUI project for every target framework, which requires the MAUI workload (`dotnet workload install maui`) and Android/iOS SDKs.

## Architecture

App projects under `ClubAjedrez/`, plus two test projects at the root:

- **`ClubAjedrez.Shared`** (Razor class library) — all shared UI: pages (`Pages/`), layout (`Layout/`), `Routes.razor`, and static assets (`wwwroot/`: `app.css`, served as `_content/ClubAjedrez.Shared/...`). **New pages and components belong here** so both hosts get them.
- **`ClubAjedrez.Web`** (ASP.NET Core server) — hosts `App.razor`, which renders `Routes` with `@rendermode="InteractiveAuto"` (Server first, then WebAssembly). `Program.cs` registers the Shared and Web.Client assemblies via `AddAdditionalAssemblies`.
- **`ClubAjedrez.Web.Client`** (Blazor WebAssembly) — the WASM half of InteractiveAuto; also holds web-only components such as `ReconnectModal`.
- **`ClubAjedrez`** (MAUI app) — native shell; `MainPage.xaml` hosts a `BlazorWebView` that mounts `ClubAjedrez.Shared.Routes` into `wwwroot/index.html`.

**Platform abstraction pattern:** When shared code needs something platform-specific, define an interface in `ClubAjedrez.Shared/Services` (there are none yet; the template's `IFormFactor` was removed); each host (Web, Web.Client, MAUI) provides its own implementation in its `Services/` folder and registers it in its own `Program.cs` / `MauiProgram.cs`. Any new platform-specific service must be registered in **all three** hosts, and because of InteractiveAuto, components must work under both Server and WebAssembly execution.

### UI: MudBlazor (no Bootstrap)

All UI uses **MudBlazor 9.x** (referenced from `ClubAjedrez.Shared`). Bootstrap has been removed. Don't reintroduce it or mix frameworks.

- Each host calls `AddMudServices()` (Web, Web.Client, MAUI) and loads `_content/MudBlazor/MudBlazor.min.css` and `MudBlazor.min.js` (`ClubAjedrez.Web/Components/App.razor`, `ClubAjedrez/wwwroot/index.html`). No Google Fonts link: it must work offline, so it falls back to system fonts.
- `MainLayout` holds `MudThemeProvider`, `MudPopoverProvider`, `MudDialogProvider` and `MudSnackbarProvider`, plus `MudLayout` with `MudAppBar` and a responsive `MudDrawer` (`NavMenu` is a `MudNavMenu`). Page titles use `<MudText Typo="Typo.h4" HtmlTag="h1">` because `Routes` focuses `h1` on navigation.
- Patterns (see `Pages/Personas/`):
  - Lists: `MudTable` with `Breakpoint.Sm`, which stacks rows as cards on mobile.
  - Delete: confirm with `IDialogService.ShowMessageBoxAsync`.
  - Results: `ISnackbar` for success, `MudAlert` for errors.
  - Forms: `EditForm novalidate` + `DataAnnotationsValidator` with `MudTextField For=… InputId=…`, so validation comes from the shared request DTO. `novalidate` is required, because `Required="true"`/`type=email` otherwise trigger browser-native validation that blocks the submit silently.
  - `MudDatePicker` binds `DateTime?`, so convert to/from the `DateOnly?` used in contracts.
- MudBlazor 9 requires `Microsoft.AspNetCore.Components.*` ≥ 10.0.1. Keep those packages on the same patch version across Shared, Web and Web.Client (currently 10.0.12).

### Data access: API + Refit

The UI never touches the database. All CRUD goes through a REST API, called from the UI with **Refit**:

- **`ClubAjedrez.Api`** — ASP.NET Core minimal API + EF Core on SQL Server. Endpoints are grouped per entity in `Endpoints/` (e.g. `PersonasEndpoints.MapPersonasEndpoints`); entities and `ClubAjedrezDbContext` live in `Data/`. Requests are validated with the DataAnnotations on the request type and return `ValidationProblem` (400). CORS (`Cors:Origins`) allows the web app's origins, because the WebAssembly client calls the API from the browser.
- **`ClubAjedrez.Contracts`** — the contract shared by the API and the UI: DTOs/requests and Refit interfaces per entity (`Personas/IPersonasApi.cs`), plus `AddClubAjedrezApi(baseUri)`, which each host (Web, Web.Client, MAUI) calls with its own base URL (`Api:BaseUrl` in config for the web hosts; hardcoded per platform in `MauiProgram.cs`, using `http://10.0.2.2:5207` on the Android emulator).
- **Refit 16 uses no reflection:** clients are registered with `AddRefitGeneratedClient` and a source-generated `ClubAjedrezJsonContext`. **Every type that travels through a Refit interface must be added as `[JsonSerializable]` to that context**, or calls throw `NotSupportedException` at runtime.
- Adding a new entity: entity mapped to the existing table in `ClubAjedrezDbContext` (with the conventions below), `MapXxxEndpoints` registered in `Program.cs`, DTO/request + Refit interface in Contracts, JSON context entries, registration in `AddClubAjedrezApi`, and pages under `ClubAjedrez.Shared/Pages/<Entity>/`.
- Pages catch **`ApiExceptionBase`** and show an error. Refit 16 throws `ApiException` for HTTP error responses and `ApiRequestException` (not `HttpRequestException`) when the request can't be sent, e.g. the API isn't running; both derive from `ApiExceptionBase`. bUnit tests replace the Refit interface with an NSubstitute mock (see `ClubAjedrez.Test/PersonasTests.cs`).

### Functional design (`readme.md`)

`readme.md` (in Spanish) is the functional spec: domain model, business rules and the sync design. Read the relevant section before working on an entity. Key points that drive the code:

- **Offline-first (planned, not implemented):** MAUI caches in SQLite, web in IndexedDB. The server (SQL Server via the API) is always the source of truth. Clients keep `Id`, `VersionServidor` and `PendienteDeGuardar` per record and send the original `Version` when saving. No merges and no generic sync infrastructure (no SyncChange/SyncOperation/cursors).
- **Conflicts: the server wins.** Only the server increments `Version`. On a mismatch the API rejects the update with 409 and returns the current server version. The UI offers "Actualizar y descartar mis cambios". A successful save returns the updated record (with its new `Version`). `PUT /api/personas` returns 200 with the updated `PersonaDto`. On a conflict it returns 409 with a `Conflicto<T>` body (`Contracts/Conflicto.cs`: `Mensaje` + `Actual`, the current server record). Clients read it with `ApiException.GetContentAsAsync<Conflicto<T>>()`, and each `Conflicto<T>` must be in `ClubAjedrezJsonContext`. Use the same pattern for other entities. The UI pattern lives in `PersonaForm.razor`:
  - On 409, show a warning and disable Guardar.
  - "Actualizar y descartar mis cambios" replaces the form with `Actual`, or re-fetches with `GetByIdAsync` if the body can't be read.
  - Never merge.
- **The API owns business rules** (versions, conflicts, ascensos, máximo de ascensos) and must validate user, permissions, ids and relations. Never trust client data. Operations touching several entities (e.g. registering an ascenso) run in one transaction.
- **Authorization:** `Usuario → UsuarioRol → Rol → RolPermiso → Permiso`, enforced with authorization policies in the API. A `CargoDirectivo` (Presidente…) is **not** an application role.
- **Domain rules that are easy to get wrong:**
  - `Persona` is anyone (club players, external rivals, directiva, users). `Jugador` is a Persona's link to the club as a player.
  - `Partida` uses `BlancasPersonaId`/`NegrasPersonaId` (not `JugadorId`), so the rival can be external.
  - `Categoria.Nivel`: 1 is the highest category.
  - `Torneo.NumeroMaxAscensos`: `NULL` = no ascensos rule, `0` = none allowed, `>0` = max.
  - Ascensos never change the player's administrative team (`JugadorEquipoTemporada`). They are tracked in `SituacionJugadorTorneo` and `AscensoJugador`.
  - `Disponibilidad` (forecast) and `ParticipacionJugador` (actual) are independent.

### Database (database-first)

The database is the user's local SQL Server instance **`ULPT0176`**, database **`clubAjedrez`** (Windows auth; connection string `ClubAjedrez` in `ClubAjedrez.Api/appsettings.Development.json`). **The user owns the schema: there are no EF Core migrations and the API must never create or alter tables.** Map existing tables by hand in `ClubAjedrezDbContext` (`ToTable`, column lengths matching the DB). There are no triggers, views or stored procedures.

Every table follows the same conventions, and the API is responsible for maintaining them:

- `<Tabla>Id uniqueidentifier` key with default `newsequentialid()` (let SQL Server generate it).
- `FechaCreacion` / `FechaModificacion` (`datetime2`, UTC, default `sysutcdatetime()`): set `FechaModificacion` on every update.
- `Version bigint` (default 1): app-managed optimistic concurrency token. Clients send back the version they read; updates increment it, and a mismatch returns **409**.
- `Eliminado bit`: **soft delete** (rows are referenced by many FKs). Delete = set `Eliminado = 1` (+ version/date); a global query filter hides deleted rows.

#### Schema changes: versioned SQL scripts

The schema is a first version and will keep evolving. Every change is a numbered SQL script in `Database/Migrations/` (`0001_esquema_inicial.sql`, `0002_<descripcion>.sql`, …), committed together with the matching API changes:

- **Never edit a script that has already been applied** (not even to fix it): write a new one. Never change the schema by hand in SSMS without a script.
- `0001_esquema_inicial.sql` is the baseline (the schema as of 2026-10-13, generated with SMO and verified to recreate an identical schema). It is **already applied on ULPT0176** and must not be run there; it is for creating a new empty database (requires SQL Server 2019+ and collation `Modern_Spanish_CI_AS`).
- New tables must follow the conventions above. Name every constraint explicitly (`DF_<Tabla>_<Columna>`, `FK_…`, `UQ_…`, `CK_…`): the `newsequentialid()` defaults on the `<Tabla>Id` columns in the baseline have system-generated names, so a script that drops them must look the name up in `sys.default_constraints`.
- Seed/reference data (roles, permisos, categorías…) goes in idempotent scripts (e.g. `MERGE`), separate from schema changes. All tables were empty at baseline.
- After each script, update the mapping in `ClubAjedrezDbContext` (and contracts/pages if exposed data changes) in the same change.
- **Planned, not set up yet:** a `ClubAjedrez.Database` console project using **DbUp** that applies pending scripts from `Database/Migrations/` and records them in a `SchemaVersions` table. When it is created, `0001` must be marked as already applied in the existing database instead of being executed.

Until then, apply a script manually: `sqlcmd -S ULPT0176 -E -C -b -f 65001 -d clubAjedrez -i Database/Migrations/<script>.sql`

**Naming: use the database names.** Entities, endpoints, contracts and pages are named after the table (`Persona` → `/api/personas`, `PersonaDto`, `IPersonasApi`, `Pages/Personas/`, route `/personas`). Do not introduce domain terms that don't exist in the schema (e.g. there is no "socio").

### Tests

- **`ClubAjedrez.Test`** (project file `ClubAjedrez.Tests.csproj`, namespace `ClubAjedrez.Tests`) — xUnit + bUnit + NSubstitute; references only `ClubAjedrez.Shared` (and Contracts through it). Test classes inherit **`MudTestContext`** (registers MudBlazor services, loose JSInterop, and `IAsyncLifetime` so xUnit disposes asynchronously; MudBlazor services fail on sync dispose) and use `Render<T>()`. Services required by components must be registered/mocked in the test context. Dialogs render inside a `MudDialogProvider`, so render one in the test (`Render<MudDialogProvider>()`) and click its buttons. Select inputs by their `InputId` (`#nombre`), errors by `.mud-alert`.
- **`ClubAjedrez.PlaywrightTests`** — xUnit + Playwright E2E tests: browser → Web → API → SQL Server (see `PersonasE2ETests.cs`). **Every feature/page needs Playwright E2E tests as well as bUnit tests.** bUnit doesn't run the real browser, so it misses things like native HTML validation blocking a submit. That happened with the persona form: it needs `novalidate` on the `EditForm`.
  - `E2EFixture` (class fixture) provides the browser, `Api` (a Playwright request context for preparing data through the API) and `AbrirAsync(ruta)`.
  - `AbrirAsync` waits for `[data-interactive='true']`, which `MainLayout` renders once Blazor is interactive. Under InteractiveAuto the page is prerendered first, and clicks or typing before that are lost.
  - Config comes from env vars `E2E_WEB_URL`, `E2E_API_URL`, `E2E_DB` and `E2E_HEADED`, with defaults for local dev.
  - Test data **must** use emails ending in `@e2e.test` (`E2EFixture.EmailUnico()`). The fixture hard-deletes those rows from `Persona` before and after the run. Never leave test rows in the dev DB. Extend the cleanup when tests start creating other entities.
  - Use role/text locators (`GetByRole`, `GetByText`) and input ids, not CSS framework classes. To fill a `MudTextField`, use `FillAsync` and then `Tab`, because it binds on `change`.

## Spec-driven workflow

`my-project/` contains a GitHub Spec Kit setup (v1.1.2, PowerShell scripts) with `speckit-*` skills in `my-project/.claude/skills/` (specify → clarify → plan → tasks → implement, plus analyze/checklist/constitution). The constitution at `my-project/.specify/memory/constitution.md` is still the unfilled template.
