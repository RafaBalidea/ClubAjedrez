-- =============================================================================
-- 0001_esquema_inicial.sql
--
-- Script de partida: esquema de la primera versión de la base de datos
-- clubAjedrez tal como estaba en ULPT0176 el 13/10/2026 (28 tablas, sin datos).
-- Generado con SQL Server Management Objects (el motor de "Generar scripts" de SSMS).
--
-- YA ESTÁ APLICADO en ULPT0176/clubAjedrez: no ejecutarlo allí. Sirve para crear
-- desde cero una base de datos nueva y vacía (otro equipo, pruebas, producción).
-- Requisitos de la base de datos: SQL Server 2019 o posterior,
-- intercalación Modern_Spanish_CI_AS.
--
-- No modificar este script: los cambios de esquema van en scripts nuevos
-- (0002_..., 0003_...). Ver "Database" en CLAUDE.md.
-- =============================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===== Tablas =====

-- Articulo
CREATE TABLE [dbo].[Articulo](
	[ArticuloId] [uniqueidentifier] NOT NULL,
	[Titulo] [nvarchar](300) NOT NULL,
	[Resumen] [nvarchar](1000) NULL,
	[Contenido] [nvarchar](max) NOT NULL,
	[ImagenUrl] [nvarchar](500) NULL,
	[Publicado] [bit] NOT NULL,
	[FechaPublicacion] [datetime2](3) NULL,
	[UsuarioAltaId] [uniqueidentifier] NULL,
	[UsuarioModificacionId] [uniqueidentifier] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Articulo] PRIMARY KEY CLUSTERED 
(
	[ArticuloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Articulo_FechaModificacion] ON [dbo].[Articulo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articulo] ADD  DEFAULT (newsequentialid()) FOR [ArticuloId]
GO
ALTER TABLE [dbo].[Articulo] ADD  CONSTRAINT [DF_Articulo_Publicado]  DEFAULT ((0)) FOR [Publicado]
GO
ALTER TABLE [dbo].[Articulo] ADD  CONSTRAINT [DF_Articulo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Articulo] ADD  CONSTRAINT [DF_Articulo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Articulo] ADD  CONSTRAINT [DF_Articulo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Articulo] ADD  CONSTRAINT [DF_Articulo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- ArticuloCategoria
CREATE TABLE [dbo].[ArticuloCategoria](
	[ArticuloCategoriaId] [uniqueidentifier] NOT NULL,
	[ArticuloId] [uniqueidentifier] NOT NULL,
	[CategoriaArticuloId] [uniqueidentifier] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_ArticuloCategoria] PRIMARY KEY CLUSTERED 
(
	[ArticuloCategoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ArticuloCategoria] UNIQUE NONCLUSTERED 
(
	[ArticuloId] ASC,
	[CategoriaArticuloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ArticuloCategoria_FechaModificacion] ON [dbo].[ArticuloCategoria]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArticuloCategoria] ADD  DEFAULT (newsequentialid()) FOR [ArticuloCategoriaId]
GO
ALTER TABLE [dbo].[ArticuloCategoria] ADD  CONSTRAINT [DF_ArticuloCategoria_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[ArticuloCategoria] ADD  CONSTRAINT [DF_ArticuloCategoria_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[ArticuloCategoria] ADD  CONSTRAINT [DF_ArticuloCategoria_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[ArticuloCategoria] ADD  CONSTRAINT [DF_ArticuloCategoria_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- AscensoJugador
CREATE TABLE [dbo].[AscensoJugador](
	[AscensoJugadorId] [uniqueidentifier] NOT NULL,
	[SituacionJugadorTorneoId] [uniqueidentifier] NOT NULL,
	[JugadorId] [uniqueidentifier] NOT NULL,
	[TorneoId] [uniqueidentifier] NOT NULL,
	[RondaId] [uniqueidentifier] NOT NULL,
	[NumeroAscenso] [int] NOT NULL,
	[CategoriaOrigenId] [uniqueidentifier] NOT NULL,
	[CategoriaDestinoId] [uniqueidentifier] NOT NULL,
	[EquipoOrigenId] [uniqueidentifier] NOT NULL,
	[EquipoDestinoTemporadaId] [uniqueidentifier] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_AscensoJugador] PRIMARY KEY CLUSTERED 
(
	[AscensoJugadorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_AscensoJugador_Numero] UNIQUE NONCLUSTERED 
(
	[JugadorId] ASC,
	[TorneoId] ASC,
	[NumeroAscenso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AscensoJugador_FechaModificacion] ON [dbo].[AscensoJugador]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AscensoJugador] ADD  DEFAULT (newsequentialid()) FOR [AscensoJugadorId]
GO
ALTER TABLE [dbo].[AscensoJugador] ADD  CONSTRAINT [DF_AscensoJugador_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[AscensoJugador] ADD  CONSTRAINT [DF_AscensoJugador_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[AscensoJugador] ADD  CONSTRAINT [DF_AscensoJugador_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[AscensoJugador] ADD  CONSTRAINT [DF_AscensoJugador_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [CK_AscensoJugador_Numero] CHECK  (([NumeroAscenso]>(0)))
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [CK_AscensoJugador_Numero]
GO

-- CargoDirectivo
CREATE TABLE [dbo].[CargoDirectivo](
	[CargoDirectivoId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_CargoDirectivo] PRIMARY KEY CLUSTERED 
(
	[CargoDirectivoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CargoDirectivo_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CargoDirectivo] ADD  DEFAULT (newsequentialid()) FOR [CargoDirectivoId]
GO
ALTER TABLE [dbo].[CargoDirectivo] ADD  CONSTRAINT [DF_CargoDirectivo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[CargoDirectivo] ADD  CONSTRAINT [DF_CargoDirectivo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[CargoDirectivo] ADD  CONSTRAINT [DF_CargoDirectivo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[CargoDirectivo] ADD  CONSTRAINT [DF_CargoDirectivo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Categoria
CREATE TABLE [dbo].[Categoria](
	[CategoriaId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Nivel] [int] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Categoria] PRIMARY KEY CLUSTERED 
(
	[CategoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Categoria_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Categoria_FechaModificacion] ON [dbo].[Categoria]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Categoria] ADD  DEFAULT (newsequentialid()) FOR [CategoriaId]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Categoria] ADD  CONSTRAINT [DF_Categoria_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[Categoria]  WITH CHECK ADD  CONSTRAINT [CK_Categoria_Nivel] CHECK  (([Nivel]>(0)))
GO
ALTER TABLE [dbo].[Categoria] CHECK CONSTRAINT [CK_Categoria_Nivel]
GO

-- CategoriaArticulo
CREATE TABLE [dbo].[CategoriaArticulo](
	[CategoriaArticuloId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_CategoriaArticulo] PRIMARY KEY CLUSTERED 
(
	[CategoriaArticuloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_CategoriaArticulo_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_CategoriaArticulo_FechaModificacion] ON [dbo].[CategoriaArticulo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CategoriaArticulo] ADD  DEFAULT (newsequentialid()) FOR [CategoriaArticuloId]
GO
ALTER TABLE [dbo].[CategoriaArticulo] ADD  CONSTRAINT [DF_CategoriaArticulo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[CategoriaArticulo] ADD  CONSTRAINT [DF_CategoriaArticulo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[CategoriaArticulo] ADD  CONSTRAINT [DF_CategoriaArticulo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[CategoriaArticulo] ADD  CONSTRAINT [DF_CategoriaArticulo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Club
CREATE TABLE [dbo].[Club](
	[ClubId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[CIF] [nvarchar](20) NULL,
	[Email] [nvarchar](200) NULL,
	[Telefono] [nvarchar](50) NULL,
	[Direccion] [nvarchar](300) NULL,
	[CodigoPostal] [nvarchar](10) NULL,
	[Localidad] [nvarchar](100) NULL,
	[Provincia] [nvarchar](100) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Club] PRIMARY KEY CLUSTERED 
(
	[ClubId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Club_FechaModificacion] ON [dbo].[Club]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Club] ADD  DEFAULT (newsequentialid()) FOR [ClubId]
GO
ALTER TABLE [dbo].[Club] ADD  CONSTRAINT [DF_Club_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Club] ADD  CONSTRAINT [DF_Club_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Club] ADD  CONSTRAINT [DF_Club_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Club] ADD  CONSTRAINT [DF_Club_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Disponibilidad
CREATE TABLE [dbo].[Disponibilidad](
	[DisponibilidadId] [uniqueidentifier] NOT NULL,
	[RondaId] [uniqueidentifier] NOT NULL,
	[JugadorId] [uniqueidentifier] NOT NULL,
	[Disponible] [bit] NOT NULL,
	[FechaRespuesta] [datetime2](3) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Disponibilidad] PRIMARY KEY CLUSTERED 
(
	[DisponibilidadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Disponibilidad_Ronda_Jugador] UNIQUE NONCLUSTERED 
(
	[RondaId] ASC,
	[JugadorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Disponibilidad_FechaModificacion] ON [dbo].[Disponibilidad]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Disponibilidad] ADD  DEFAULT (newsequentialid()) FOR [DisponibilidadId]
GO
ALTER TABLE [dbo].[Disponibilidad] ADD  CONSTRAINT [DF_Disponibilidad_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Disponibilidad] ADD  CONSTRAINT [DF_Disponibilidad_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Disponibilidad] ADD  CONSTRAINT [DF_Disponibilidad_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Disponibilidad] ADD  CONSTRAINT [DF_Disponibilidad_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- DocumentoClub
CREATE TABLE [dbo].[DocumentoClub](
	[DocumentoClubId] [uniqueidentifier] NOT NULL,
	[ClubId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
	[Ruta] [nvarchar](500) NULL,
	[Tipo] [nvarchar](100) NULL,
	[FechaDocumento] [date] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_DocumentoClub] PRIMARY KEY CLUSTERED 
(
	[DocumentoClubId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DocumentoClub_FechaModificacion] ON [dbo].[DocumentoClub]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentoClub] ADD  DEFAULT (newsequentialid()) FOR [DocumentoClubId]
GO
ALTER TABLE [dbo].[DocumentoClub] ADD  CONSTRAINT [DF_DocumentoClub_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[DocumentoClub] ADD  CONSTRAINT [DF_DocumentoClub_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[DocumentoClub] ADD  CONSTRAINT [DF_DocumentoClub_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[DocumentoClub] ADD  CONSTRAINT [DF_DocumentoClub_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Equipo
CREATE TABLE [dbo].[Equipo](
	[EquipoId] [uniqueidentifier] NOT NULL,
	[ClubId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Activo] [bit] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Equipo] PRIMARY KEY CLUSTERED 
(
	[EquipoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Equipo_Club_Nombre] UNIQUE NONCLUSTERED 
(
	[ClubId] ASC,
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Equipo_FechaModificacion] ON [dbo].[Equipo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Equipo] ADD  DEFAULT (newsequentialid()) FOR [EquipoId]
GO
ALTER TABLE [dbo].[Equipo] ADD  CONSTRAINT [DF_Equipo_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Equipo] ADD  CONSTRAINT [DF_Equipo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Equipo] ADD  CONSTRAINT [DF_Equipo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Equipo] ADD  CONSTRAINT [DF_Equipo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Equipo] ADD  CONSTRAINT [DF_Equipo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- EquipoTemporada
CREATE TABLE [dbo].[EquipoTemporada](
	[EquipoTemporadaId] [uniqueidentifier] NOT NULL,
	[EquipoId] [uniqueidentifier] NOT NULL,
	[TemporadaId] [uniqueidentifier] NOT NULL,
	[CategoriaId] [uniqueidentifier] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_EquipoTemporada] PRIMARY KEY CLUSTERED 
(
	[EquipoTemporadaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_EquipoTemporada] UNIQUE NONCLUSTERED 
(
	[EquipoId] ASC,
	[TemporadaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EquipoTemporada_FechaModificacion] ON [dbo].[EquipoTemporada]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EquipoTemporada] ADD  DEFAULT (newsequentialid()) FOR [EquipoTemporadaId]
GO
ALTER TABLE [dbo].[EquipoTemporada] ADD  CONSTRAINT [DF_EquipoTemporada_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[EquipoTemporada] ADD  CONSTRAINT [DF_EquipoTemporada_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[EquipoTemporada] ADD  CONSTRAINT [DF_EquipoTemporada_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[EquipoTemporada] ADD  CONSTRAINT [DF_EquipoTemporada_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Jugador
CREATE TABLE [dbo].[Jugador](
	[JugadorId] [uniqueidentifier] NOT NULL,
	[PersonaId] [uniqueidentifier] NOT NULL,
	[NumeroFederado] [nvarchar](50) NULL,
	[Elo] [int] NULL,
	[FechaAlta] [date] NULL,
	[FechaBaja] [date] NULL,
	[Activo] [bit] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Jugador] PRIMARY KEY CLUSTERED 
(
	[JugadorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Jugador_Persona] UNIQUE NONCLUSTERED 
(
	[PersonaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Jugador_FechaModificacion] ON [dbo].[Jugador]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_Jugador_NumeroFederado] ON [dbo].[Jugador]
(
	[NumeroFederado] ASC
)
WHERE ([NumeroFederado] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Jugador] ADD  DEFAULT (newsequentialid()) FOR [JugadorId]
GO
ALTER TABLE [dbo].[Jugador] ADD  CONSTRAINT [DF_Jugador_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Jugador] ADD  CONSTRAINT [DF_Jugador_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Jugador] ADD  CONSTRAINT [DF_Jugador_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Jugador] ADD  CONSTRAINT [DF_Jugador_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Jugador] ADD  CONSTRAINT [DF_Jugador_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- JugadorEquipoTemporada
CREATE TABLE [dbo].[JugadorEquipoTemporada](
	[JugadorEquipoTemporadaId] [uniqueidentifier] NOT NULL,
	[JugadorId] [uniqueidentifier] NOT NULL,
	[EquipoTemporadaId] [uniqueidentifier] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_JugadorEquipoTemporada] PRIMARY KEY CLUSTERED 
(
	[JugadorEquipoTemporadaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_JugadorEquipoTemporada_FechaModificacion] ON [dbo].[JugadorEquipoTemporada]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_JugadorEquipoTemporada_Jugador] ON [dbo].[JugadorEquipoTemporada]
(
	[JugadorId] ASC,
	[EquipoTemporadaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] ADD  DEFAULT (newsequentialid()) FOR [JugadorEquipoTemporadaId]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] ADD  CONSTRAINT [DF_JugadorEquipoTemporada_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] ADD  CONSTRAINT [DF_JugadorEquipoTemporada_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] ADD  CONSTRAINT [DF_JugadorEquipoTemporada_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] ADD  CONSTRAINT [DF_JugadorEquipoTemporada_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- MiembroDirectiva
CREATE TABLE [dbo].[MiembroDirectiva](
	[MiembroDirectivaId] [uniqueidentifier] NOT NULL,
	[ClubId] [uniqueidentifier] NOT NULL,
	[PersonaId] [uniqueidentifier] NOT NULL,
	[CargoDirectivoId] [uniqueidentifier] NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_MiembroDirectiva] PRIMARY KEY CLUSTERED 
(
	[MiembroDirectivaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MiembroDirectiva_FechaModificacion] ON [dbo].[MiembroDirectiva]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MiembroDirectiva] ADD  DEFAULT (newsequentialid()) FOR [MiembroDirectivaId]
GO
ALTER TABLE [dbo].[MiembroDirectiva] ADD  CONSTRAINT [DF_MiembroDirectiva_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[MiembroDirectiva] ADD  CONSTRAINT [DF_MiembroDirectiva_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[MiembroDirectiva] ADD  CONSTRAINT [DF_MiembroDirectiva_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[MiembroDirectiva] ADD  CONSTRAINT [DF_MiembroDirectiva_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- ParticipacionJugador
CREATE TABLE [dbo].[ParticipacionJugador](
	[ParticipacionJugadorId] [uniqueidentifier] NOT NULL,
	[RondaId] [uniqueidentifier] NOT NULL,
	[JugadorId] [uniqueidentifier] NOT NULL,
	[JugadorEquipoTemporadaId] [uniqueidentifier] NOT NULL,
	[EquipoParticipacionId] [uniqueidentifier] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_ParticipacionJugador] PRIMARY KEY CLUSTERED 
(
	[ParticipacionJugadorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_ParticipacionJugador_Ronda_Jugador] UNIQUE NONCLUSTERED 
(
	[RondaId] ASC,
	[JugadorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ParticipacionJugador_FechaModificacion] ON [dbo].[ParticipacionJugador]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ParticipacionJugador] ADD  DEFAULT (newsequentialid()) FOR [ParticipacionJugadorId]
GO
ALTER TABLE [dbo].[ParticipacionJugador] ADD  CONSTRAINT [DF_ParticipacionJugador_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[ParticipacionJugador] ADD  CONSTRAINT [DF_ParticipacionJugador_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[ParticipacionJugador] ADD  CONSTRAINT [DF_ParticipacionJugador_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[ParticipacionJugador] ADD  CONSTRAINT [DF_ParticipacionJugador_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Partida
CREATE TABLE [dbo].[Partida](
	[PartidaId] [uniqueidentifier] NOT NULL,
	[RondaId] [uniqueidentifier] NOT NULL,
	[BlancasPersonaId] [uniqueidentifier] NOT NULL,
	[NegrasPersonaId] [uniqueidentifier] NOT NULL,
	[Resultado] [char](1) NULL,
	[EloBlancas] [int] NULL,
	[EloNegras] [int] NULL,
	[ECO] [nvarchar](10) NULL,
	[PGN] [nvarchar](max) NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Partida] PRIMARY KEY CLUSTERED 
(
	[PartidaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Partida_FechaModificacion] ON [dbo].[Partida]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Partida] ADD  DEFAULT (newsequentialid()) FOR [PartidaId]
GO
ALTER TABLE [dbo].[Partida] ADD  CONSTRAINT [DF_Partida_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Partida] ADD  CONSTRAINT [DF_Partida_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Partida] ADD  CONSTRAINT [DF_Partida_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Partida] ADD  CONSTRAINT [DF_Partida_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[Partida]  WITH CHECK ADD  CONSTRAINT [CK_Partida_JugadoresDistintos] CHECK  (([BlancasPersonaId]<>[NegrasPersonaId]))
GO
ALTER TABLE [dbo].[Partida] CHECK CONSTRAINT [CK_Partida_JugadoresDistintos]
GO
ALTER TABLE [dbo].[Partida]  WITH CHECK ADD  CONSTRAINT [CK_Partida_Resultado] CHECK  (([Resultado]='D' OR [Resultado]='0' OR [Resultado]='1' OR [Resultado] IS NULL))
GO
ALTER TABLE [dbo].[Partida] CHECK CONSTRAINT [CK_Partida_Resultado]
GO

-- PartidaEquipo
CREATE TABLE [dbo].[PartidaEquipo](
	[PartidaEquipoId] [uniqueidentifier] NOT NULL,
	[PartidaId] [uniqueidentifier] NOT NULL,
	[PersonaId] [uniqueidentifier] NOT NULL,
	[EquipoTemporadaId] [uniqueidentifier] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_PartidaEquipo] PRIMARY KEY CLUSTERED 
(
	[PartidaEquipoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_PartidaEquipo_Partida_Persona] UNIQUE NONCLUSTERED 
(
	[PartidaId] ASC,
	[PersonaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_PartidaEquipo_FechaModificacion] ON [dbo].[PartidaEquipo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartidaEquipo] ADD  DEFAULT (newsequentialid()) FOR [PartidaEquipoId]
GO
ALTER TABLE [dbo].[PartidaEquipo] ADD  CONSTRAINT [DF_PartidaEquipo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[PartidaEquipo] ADD  CONSTRAINT [DF_PartidaEquipo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[PartidaEquipo] ADD  CONSTRAINT [DF_PartidaEquipo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[PartidaEquipo] ADD  CONSTRAINT [DF_PartidaEquipo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Permiso
CREATE TABLE [dbo].[Permiso](
	[PermisoId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Permiso] PRIMARY KEY CLUSTERED 
(
	[PermisoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Permiso_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Permiso_FechaModificacion] ON [dbo].[Permiso]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Permiso] ADD  DEFAULT (newsequentialid()) FOR [PermisoId]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Permiso] ADD  CONSTRAINT [DF_Permiso_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Persona
CREATE TABLE [dbo].[Persona](
	[PersonaId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Apellidos] [nvarchar](200) NOT NULL,
	[DNI] [nvarchar](20) NULL,
	[Email] [nvarchar](200) NULL,
	[Telefono] [nvarchar](50) NULL,
	[FechaNacimiento] [date] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[PersonaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Persona_DNI] ON [dbo].[Persona]
(
	[DNI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Persona_FechaModificacion] ON [dbo].[Persona]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Persona] ADD  DEFAULT (newsequentialid()) FOR [PersonaId]
GO
ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Persona] ADD  CONSTRAINT [DF_Persona_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Rol
CREATE TABLE [dbo].[Rol](
	[RolId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Descripcion] [nvarchar](500) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Rol] PRIMARY KEY CLUSTERED 
(
	[RolId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Rol_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Rol_FechaModificacion] ON [dbo].[Rol]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rol] ADD  DEFAULT (newsequentialid()) FOR [RolId]
GO
ALTER TABLE [dbo].[Rol] ADD  CONSTRAINT [DF_Rol_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Rol] ADD  CONSTRAINT [DF_Rol_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Rol] ADD  CONSTRAINT [DF_Rol_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Rol] ADD  CONSTRAINT [DF_Rol_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- RolPermiso
CREATE TABLE [dbo].[RolPermiso](
	[RolPermisoId] [uniqueidentifier] NOT NULL,
	[RolId] [uniqueidentifier] NOT NULL,
	[PermisoId] [uniqueidentifier] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_RolPermiso] PRIMARY KEY CLUSTERED 
(
	[RolPermisoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_RolPermiso] UNIQUE NONCLUSTERED 
(
	[RolId] ASC,
	[PermisoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_RolPermiso_FechaModificacion] ON [dbo].[RolPermiso]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  DEFAULT (newsequentialid()) FOR [RolPermisoId]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  CONSTRAINT [DF_RolPermiso_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  CONSTRAINT [DF_RolPermiso_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  CONSTRAINT [DF_RolPermiso_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[RolPermiso] ADD  CONSTRAINT [DF_RolPermiso_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Ronda
CREATE TABLE [dbo].[Ronda](
	[RondaId] [uniqueidentifier] NOT NULL,
	[TorneoCategoriaId] [uniqueidentifier] NOT NULL,
	[Numero] [int] NOT NULL,
	[Fecha] [date] NULL,
	[Hora] [time](7) NULL,
	[Lugar] [nvarchar](300) NULL,
	[Observaciones] [nvarchar](1000) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Ronda] PRIMARY KEY CLUSTERED 
(
	[RondaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Ronda_TorneoCategoria_Numero] UNIQUE NONCLUSTERED 
(
	[TorneoCategoriaId] ASC,
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Ronda_FechaModificacion] ON [dbo].[Ronda]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Ronda] ADD  DEFAULT (newsequentialid()) FOR [RondaId]
GO
ALTER TABLE [dbo].[Ronda] ADD  CONSTRAINT [DF_Ronda_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Ronda] ADD  CONSTRAINT [DF_Ronda_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Ronda] ADD  CONSTRAINT [DF_Ronda_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Ronda] ADD  CONSTRAINT [DF_Ronda_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[Ronda]  WITH CHECK ADD  CONSTRAINT [CK_Ronda_Numero] CHECK  (([Numero]>(0)))
GO
ALTER TABLE [dbo].[Ronda] CHECK CONSTRAINT [CK_Ronda_Numero]
GO

-- SituacionJugadorTorneo
CREATE TABLE [dbo].[SituacionJugadorTorneo](
	[SituacionJugadorTorneoId] [uniqueidentifier] NOT NULL,
	[JugadorId] [uniqueidentifier] NOT NULL,
	[TorneoId] [uniqueidentifier] NOT NULL,
	[EquipoOrigenId] [uniqueidentifier] NOT NULL,
	[CategoriaOrigenId] [uniqueidentifier] NOT NULL,
	[EquipoActualId] [uniqueidentifier] NULL,
	[CategoriaActualId] [uniqueidentifier] NULL,
	[AscensosRealizados] [int] NOT NULL,
	[AscensoCompletado] [bit] NOT NULL,
	[FechaFijacion] [datetime2](3) NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_SituacionJugadorTorneo] PRIMARY KEY CLUSTERED 
(
	[SituacionJugadorTorneoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_SituacionJugadorTorneo] UNIQUE NONCLUSTERED 
(
	[JugadorId] ASC,
	[TorneoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SituacionJugadorTorneo_FechaModificacion] ON [dbo].[SituacionJugadorTorneo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  DEFAULT (newsequentialid()) FOR [SituacionJugadorTorneoId]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_Ascensos]  DEFAULT ((0)) FOR [AscensosRealizados]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_AscensoCompletado]  DEFAULT ((0)) FOR [AscensoCompletado]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] ADD  CONSTRAINT [DF_SituacionJugadorTorneo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [CK_SituacionJugadorTorneo_Ascensos] CHECK  (([AscensosRealizados]>=(0)))
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [CK_SituacionJugadorTorneo_Ascensos]
GO

-- Temporada
CREATE TABLE [dbo].[Temporada](
	[TemporadaId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Temporada] PRIMARY KEY CLUSTERED 
(
	[TemporadaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Temporada_Nombre] UNIQUE NONCLUSTERED 
(
	[Nombre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Temporada_FechaModificacion] ON [dbo].[Temporada]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Temporada] ADD  DEFAULT (newsequentialid()) FOR [TemporadaId]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Temporada] ADD  CONSTRAINT [DF_Temporada_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Torneo
CREATE TABLE [dbo].[Torneo](
	[TorneoId] [uniqueidentifier] NOT NULL,
	[TemporadaId] [uniqueidentifier] NOT NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[NumeroMaxAscensos] [int] NULL,
	[Activo] [bit] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Torneo] PRIMARY KEY CLUSTERED 
(
	[TorneoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Torneo_FechaModificacion] ON [dbo].[Torneo]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Torneo] ADD  DEFAULT (newsequentialid()) FOR [TorneoId]
GO
ALTER TABLE [dbo].[Torneo] ADD  CONSTRAINT [DF_Torneo_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Torneo] ADD  CONSTRAINT [DF_Torneo_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Torneo] ADD  CONSTRAINT [DF_Torneo_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Torneo] ADD  CONSTRAINT [DF_Torneo_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Torneo] ADD  CONSTRAINT [DF_Torneo_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO
ALTER TABLE [dbo].[Torneo]  WITH CHECK ADD  CONSTRAINT [CK_Torneo_NumeroMaxAscensos] CHECK  (([NumeroMaxAscensos] IS NULL OR [NumeroMaxAscensos]>=(0)))
GO
ALTER TABLE [dbo].[Torneo] CHECK CONSTRAINT [CK_Torneo_NumeroMaxAscensos]
GO

-- TorneoCategoria
CREATE TABLE [dbo].[TorneoCategoria](
	[TorneoCategoriaId] [uniqueidentifier] NOT NULL,
	[TorneoId] [uniqueidentifier] NOT NULL,
	[CategoriaId] [uniqueidentifier] NULL,
	[Nombre] [nvarchar](200) NOT NULL,
	[Orden] [int] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_TorneoCategoria] PRIMARY KEY CLUSTERED 
(
	[TorneoCategoriaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_TorneoCategoria_FechaModificacion] ON [dbo].[TorneoCategoria]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  DEFAULT (newsequentialid()) FOR [TorneoCategoriaId]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  CONSTRAINT [DF_TorneoCategoria_Orden]  DEFAULT ((1)) FOR [Orden]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  CONSTRAINT [DF_TorneoCategoria_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  CONSTRAINT [DF_TorneoCategoria_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  CONSTRAINT [DF_TorneoCategoria_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[TorneoCategoria] ADD  CONSTRAINT [DF_TorneoCategoria_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- Usuario
CREATE TABLE [dbo].[Usuario](
	[UsuarioId] [uniqueidentifier] NOT NULL,
	[PersonaId] [uniqueidentifier] NULL,
	[NombreUsuario] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[PasswordHash] [nvarchar](500) NULL,
	[Activo] [bit] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Usuario_Email] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Usuario_Nombre] UNIQUE NONCLUSTERED 
(
	[NombreUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Usuario_FechaModificacion] ON [dbo].[Usuario]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Usuario] ADD  DEFAULT (newsequentialid()) FOR [UsuarioId]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Activo]  DEFAULT ((1)) FOR [Activo]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- UsuarioRol
CREATE TABLE [dbo].[UsuarioRol](
	[UsuarioRolId] [uniqueidentifier] NOT NULL,
	[UsuarioId] [uniqueidentifier] NOT NULL,
	[RolId] [uniqueidentifier] NOT NULL,
	[FechaCreacion] [datetime2](3) NOT NULL,
	[FechaModificacion] [datetime2](3) NOT NULL,
	[Version] [bigint] NOT NULL,
	[Eliminado] [bit] NOT NULL,
 CONSTRAINT [PK_UsuarioRol] PRIMARY KEY CLUSTERED 
(
	[UsuarioRolId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_UsuarioRol] UNIQUE NONCLUSTERED 
(
	[UsuarioId] ASC,
	[RolId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UsuarioRol_FechaModificacion] ON [dbo].[UsuarioRol]
(
	[FechaModificacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  DEFAULT (newsequentialid()) FOR [UsuarioRolId]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  CONSTRAINT [DF_UsuarioRol_FechaCreacion]  DEFAULT (sysutcdatetime()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  CONSTRAINT [DF_UsuarioRol_FechaModificacion]  DEFAULT (sysutcdatetime()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  CONSTRAINT [DF_UsuarioRol_Version]  DEFAULT ((1)) FOR [Version]
GO
ALTER TABLE [dbo].[UsuarioRol] ADD  CONSTRAINT [DF_UsuarioRol_Eliminado]  DEFAULT ((0)) FOR [Eliminado]
GO

-- ===== Claves foráneas =====
ALTER TABLE [dbo].[Articulo]  WITH CHECK ADD  CONSTRAINT [FK_Articulo_UsuarioAlta] FOREIGN KEY([UsuarioAltaId])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO
ALTER TABLE [dbo].[Articulo] CHECK CONSTRAINT [FK_Articulo_UsuarioAlta]
GO
ALTER TABLE [dbo].[Articulo]  WITH CHECK ADD  CONSTRAINT [FK_Articulo_UsuarioModificacion] FOREIGN KEY([UsuarioModificacionId])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO
ALTER TABLE [dbo].[Articulo] CHECK CONSTRAINT [FK_Articulo_UsuarioModificacion]
GO
ALTER TABLE [dbo].[ArticuloCategoria]  WITH CHECK ADD  CONSTRAINT [FK_ArticuloCategoria_Articulo] FOREIGN KEY([ArticuloId])
REFERENCES [dbo].[Articulo] ([ArticuloId])
GO
ALTER TABLE [dbo].[ArticuloCategoria] CHECK CONSTRAINT [FK_ArticuloCategoria_Articulo]
GO
ALTER TABLE [dbo].[ArticuloCategoria]  WITH CHECK ADD  CONSTRAINT [FK_ArticuloCategoria_Categoria] FOREIGN KEY([CategoriaArticuloId])
REFERENCES [dbo].[CategoriaArticulo] ([CategoriaArticuloId])
GO
ALTER TABLE [dbo].[ArticuloCategoria] CHECK CONSTRAINT [FK_ArticuloCategoria_Categoria]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_CategoriaDestino] FOREIGN KEY([CategoriaDestinoId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_CategoriaDestino]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_CategoriaOrigen] FOREIGN KEY([CategoriaOrigenId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_CategoriaOrigen]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_EquipoDestino] FOREIGN KEY([EquipoDestinoTemporadaId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_EquipoDestino]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_EquipoOrigen] FOREIGN KEY([EquipoOrigenId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_EquipoOrigen]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_Jugador] FOREIGN KEY([JugadorId])
REFERENCES [dbo].[Jugador] ([JugadorId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_Jugador]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_Ronda] FOREIGN KEY([RondaId])
REFERENCES [dbo].[Ronda] ([RondaId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_Ronda]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_Situacion] FOREIGN KEY([SituacionJugadorTorneoId])
REFERENCES [dbo].[SituacionJugadorTorneo] ([SituacionJugadorTorneoId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_Situacion]
GO
ALTER TABLE [dbo].[AscensoJugador]  WITH CHECK ADD  CONSTRAINT [FK_AscensoJugador_Torneo] FOREIGN KEY([TorneoId])
REFERENCES [dbo].[Torneo] ([TorneoId])
GO
ALTER TABLE [dbo].[AscensoJugador] CHECK CONSTRAINT [FK_AscensoJugador_Torneo]
GO
ALTER TABLE [dbo].[Disponibilidad]  WITH CHECK ADD  CONSTRAINT [FK_Disponibilidad_Jugador] FOREIGN KEY([JugadorId])
REFERENCES [dbo].[Jugador] ([JugadorId])
GO
ALTER TABLE [dbo].[Disponibilidad] CHECK CONSTRAINT [FK_Disponibilidad_Jugador]
GO
ALTER TABLE [dbo].[Disponibilidad]  WITH CHECK ADD  CONSTRAINT [FK_Disponibilidad_Ronda] FOREIGN KEY([RondaId])
REFERENCES [dbo].[Ronda] ([RondaId])
GO
ALTER TABLE [dbo].[Disponibilidad] CHECK CONSTRAINT [FK_Disponibilidad_Ronda]
GO
ALTER TABLE [dbo].[DocumentoClub]  WITH CHECK ADD  CONSTRAINT [FK_DocumentoClub_Club] FOREIGN KEY([ClubId])
REFERENCES [dbo].[Club] ([ClubId])
GO
ALTER TABLE [dbo].[DocumentoClub] CHECK CONSTRAINT [FK_DocumentoClub_Club]
GO
ALTER TABLE [dbo].[Equipo]  WITH CHECK ADD  CONSTRAINT [FK_Equipo_Club] FOREIGN KEY([ClubId])
REFERENCES [dbo].[Club] ([ClubId])
GO
ALTER TABLE [dbo].[Equipo] CHECK CONSTRAINT [FK_Equipo_Club]
GO
ALTER TABLE [dbo].[EquipoTemporada]  WITH CHECK ADD  CONSTRAINT [FK_EquipoTemporada_Categoria] FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[EquipoTemporada] CHECK CONSTRAINT [FK_EquipoTemporada_Categoria]
GO
ALTER TABLE [dbo].[EquipoTemporada]  WITH CHECK ADD  CONSTRAINT [FK_EquipoTemporada_Equipo] FOREIGN KEY([EquipoId])
REFERENCES [dbo].[Equipo] ([EquipoId])
GO
ALTER TABLE [dbo].[EquipoTemporada] CHECK CONSTRAINT [FK_EquipoTemporada_Equipo]
GO
ALTER TABLE [dbo].[EquipoTemporada]  WITH CHECK ADD  CONSTRAINT [FK_EquipoTemporada_Temporada] FOREIGN KEY([TemporadaId])
REFERENCES [dbo].[Temporada] ([TemporadaId])
GO
ALTER TABLE [dbo].[EquipoTemporada] CHECK CONSTRAINT [FK_EquipoTemporada_Temporada]
GO
ALTER TABLE [dbo].[Jugador]  WITH CHECK ADD  CONSTRAINT [FK_Jugador_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[Jugador] CHECK CONSTRAINT [FK_Jugador_Persona]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada]  WITH CHECK ADD  CONSTRAINT [FK_JugadorEquipoTemporada_EquipoTemporada] FOREIGN KEY([EquipoTemporadaId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] CHECK CONSTRAINT [FK_JugadorEquipoTemporada_EquipoTemporada]
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada]  WITH CHECK ADD  CONSTRAINT [FK_JugadorEquipoTemporada_Jugador] FOREIGN KEY([JugadorId])
REFERENCES [dbo].[Jugador] ([JugadorId])
GO
ALTER TABLE [dbo].[JugadorEquipoTemporada] CHECK CONSTRAINT [FK_JugadorEquipoTemporada_Jugador]
GO
ALTER TABLE [dbo].[MiembroDirectiva]  WITH CHECK ADD  CONSTRAINT [FK_MiembroDirectiva_Cargo] FOREIGN KEY([CargoDirectivoId])
REFERENCES [dbo].[CargoDirectivo] ([CargoDirectivoId])
GO
ALTER TABLE [dbo].[MiembroDirectiva] CHECK CONSTRAINT [FK_MiembroDirectiva_Cargo]
GO
ALTER TABLE [dbo].[MiembroDirectiva]  WITH CHECK ADD  CONSTRAINT [FK_MiembroDirectiva_Club] FOREIGN KEY([ClubId])
REFERENCES [dbo].[Club] ([ClubId])
GO
ALTER TABLE [dbo].[MiembroDirectiva] CHECK CONSTRAINT [FK_MiembroDirectiva_Club]
GO
ALTER TABLE [dbo].[MiembroDirectiva]  WITH CHECK ADD  CONSTRAINT [FK_MiembroDirectiva_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[MiembroDirectiva] CHECK CONSTRAINT [FK_MiembroDirectiva_Persona]
GO
ALTER TABLE [dbo].[ParticipacionJugador]  WITH CHECK ADD  CONSTRAINT [FK_ParticipacionJugador_EquipoParticipacion] FOREIGN KEY([EquipoParticipacionId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[ParticipacionJugador] CHECK CONSTRAINT [FK_ParticipacionJugador_EquipoParticipacion]
GO
ALTER TABLE [dbo].[ParticipacionJugador]  WITH CHECK ADD  CONSTRAINT [FK_ParticipacionJugador_Jugador] FOREIGN KEY([JugadorId])
REFERENCES [dbo].[Jugador] ([JugadorId])
GO
ALTER TABLE [dbo].[ParticipacionJugador] CHECK CONSTRAINT [FK_ParticipacionJugador_Jugador]
GO
ALTER TABLE [dbo].[ParticipacionJugador]  WITH CHECK ADD  CONSTRAINT [FK_ParticipacionJugador_JugadorEquipoTemporada] FOREIGN KEY([JugadorEquipoTemporadaId])
REFERENCES [dbo].[JugadorEquipoTemporada] ([JugadorEquipoTemporadaId])
GO
ALTER TABLE [dbo].[ParticipacionJugador] CHECK CONSTRAINT [FK_ParticipacionJugador_JugadorEquipoTemporada]
GO
ALTER TABLE [dbo].[ParticipacionJugador]  WITH CHECK ADD  CONSTRAINT [FK_ParticipacionJugador_Ronda] FOREIGN KEY([RondaId])
REFERENCES [dbo].[Ronda] ([RondaId])
GO
ALTER TABLE [dbo].[ParticipacionJugador] CHECK CONSTRAINT [FK_ParticipacionJugador_Ronda]
GO
ALTER TABLE [dbo].[Partida]  WITH CHECK ADD  CONSTRAINT [FK_Partida_Blancas] FOREIGN KEY([BlancasPersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[Partida] CHECK CONSTRAINT [FK_Partida_Blancas]
GO
ALTER TABLE [dbo].[Partida]  WITH CHECK ADD  CONSTRAINT [FK_Partida_Negras] FOREIGN KEY([NegrasPersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[Partida] CHECK CONSTRAINT [FK_Partida_Negras]
GO
ALTER TABLE [dbo].[Partida]  WITH CHECK ADD  CONSTRAINT [FK_Partida_Ronda] FOREIGN KEY([RondaId])
REFERENCES [dbo].[Ronda] ([RondaId])
GO
ALTER TABLE [dbo].[Partida] CHECK CONSTRAINT [FK_Partida_Ronda]
GO
ALTER TABLE [dbo].[PartidaEquipo]  WITH CHECK ADD  CONSTRAINT [FK_PartidaEquipo_Equipo] FOREIGN KEY([EquipoTemporadaId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[PartidaEquipo] CHECK CONSTRAINT [FK_PartidaEquipo_Equipo]
GO
ALTER TABLE [dbo].[PartidaEquipo]  WITH CHECK ADD  CONSTRAINT [FK_PartidaEquipo_Partida] FOREIGN KEY([PartidaId])
REFERENCES [dbo].[Partida] ([PartidaId])
GO
ALTER TABLE [dbo].[PartidaEquipo] CHECK CONSTRAINT [FK_PartidaEquipo_Partida]
GO
ALTER TABLE [dbo].[PartidaEquipo]  WITH CHECK ADD  CONSTRAINT [FK_PartidaEquipo_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[PartidaEquipo] CHECK CONSTRAINT [FK_PartidaEquipo_Persona]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Permiso] FOREIGN KEY([PermisoId])
REFERENCES [dbo].[Permiso] ([PermisoId])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Permiso]
GO
ALTER TABLE [dbo].[RolPermiso]  WITH CHECK ADD  CONSTRAINT [FK_RolPermiso_Rol] FOREIGN KEY([RolId])
REFERENCES [dbo].[Rol] ([RolId])
GO
ALTER TABLE [dbo].[RolPermiso] CHECK CONSTRAINT [FK_RolPermiso_Rol]
GO
ALTER TABLE [dbo].[Ronda]  WITH CHECK ADD  CONSTRAINT [FK_Ronda_TorneoCategoria] FOREIGN KEY([TorneoCategoriaId])
REFERENCES [dbo].[TorneoCategoria] ([TorneoCategoriaId])
GO
ALTER TABLE [dbo].[Ronda] CHECK CONSTRAINT [FK_Ronda_TorneoCategoria]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_CategoriaActual] FOREIGN KEY([CategoriaActualId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_CategoriaActual]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_CategoriaOrigen] FOREIGN KEY([CategoriaOrigenId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_CategoriaOrigen]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_EquipoActual] FOREIGN KEY([EquipoActualId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_EquipoActual]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_EquipoOrigen] FOREIGN KEY([EquipoOrigenId])
REFERENCES [dbo].[EquipoTemporada] ([EquipoTemporadaId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_EquipoOrigen]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_Jugador] FOREIGN KEY([JugadorId])
REFERENCES [dbo].[Jugador] ([JugadorId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_Jugador]
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo]  WITH CHECK ADD  CONSTRAINT [FK_SituacionJugadorTorneo_Torneo] FOREIGN KEY([TorneoId])
REFERENCES [dbo].[Torneo] ([TorneoId])
GO
ALTER TABLE [dbo].[SituacionJugadorTorneo] CHECK CONSTRAINT [FK_SituacionJugadorTorneo_Torneo]
GO
ALTER TABLE [dbo].[Torneo]  WITH CHECK ADD  CONSTRAINT [FK_Torneo_Temporada] FOREIGN KEY([TemporadaId])
REFERENCES [dbo].[Temporada] ([TemporadaId])
GO
ALTER TABLE [dbo].[Torneo] CHECK CONSTRAINT [FK_Torneo_Temporada]
GO
ALTER TABLE [dbo].[TorneoCategoria]  WITH CHECK ADD  CONSTRAINT [FK_TorneoCategoria_Categoria] FOREIGN KEY([CategoriaId])
REFERENCES [dbo].[Categoria] ([CategoriaId])
GO
ALTER TABLE [dbo].[TorneoCategoria] CHECK CONSTRAINT [FK_TorneoCategoria_Categoria]
GO
ALTER TABLE [dbo].[TorneoCategoria]  WITH CHECK ADD  CONSTRAINT [FK_TorneoCategoria_Torneo] FOREIGN KEY([TorneoId])
REFERENCES [dbo].[Torneo] ([TorneoId])
GO
ALTER TABLE [dbo].[TorneoCategoria] CHECK CONSTRAINT [FK_TorneoCategoria_Torneo]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Persona] FOREIGN KEY([PersonaId])
REFERENCES [dbo].[Persona] ([PersonaId])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Persona]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Rol] FOREIGN KEY([RolId])
REFERENCES [dbo].[Rol] ([RolId])
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Rol]
GO
ALTER TABLE [dbo].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK_UsuarioRol_Usuario] FOREIGN KEY([UsuarioId])
REFERENCES [dbo].[Usuario] ([UsuarioId])
GO
ALTER TABLE [dbo].[UsuarioRol] CHECK CONSTRAINT [FK_UsuarioRol_Usuario]
GO
