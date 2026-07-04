-- =====================================================
-- Sistema de Administración de Condominios
-- SQL Server 2022 - Base de Datos Completa
-- ISW-524 Diseño de Arquitectura de Software
-- =====================================================

-- 1. CREAR BASE DE DATOS
-- =====================================================
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'CondominioDB')
    DROP DATABASE CondominioDB;
GO

CREATE DATABASE CondominioDB;
GO

USE CondominioDB;
GO

-- 2. CREAR TABLAS
-- =====================================================

-- Tabla: Roles
CREATE TABLE Roles (
    RolId INT PRIMARY KEY IDENTITY(1,1),
    NombreRol NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255),
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabla: Permisos
CREATE TABLE Permisos (
    PermisoId INT PRIMARY KEY IDENTITY(1,1),
    NombrePermiso NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255),
    Modulo NVARCHAR(50),
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabla: Relación Roles - Permisos (Muchos a Muchos)
CREATE TABLE RolPermisos (
    RolPermisoId INT PRIMARY KEY IDENTITY(1,1),
    RolId INT NOT NULL,
    PermisoId INT NOT NULL,
    FechaAsignacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_RolPermisos_Roles FOREIGN KEY (RolId) REFERENCES Roles(RolId) ON DELETE CASCADE,
    CONSTRAINT FK_RolPermisos_Permisos FOREIGN KEY (PermisoId) REFERENCES Permisos(PermisoId) ON DELETE CASCADE,
    CONSTRAINT UK_RolPermisos UNIQUE(RolId, PermisoId)
);

-- Tabla: Usuarios
CREATE TABLE Usuarios (
    UsuarioId INT PRIMARY KEY IDENTITY(1,1),
    NombreUsuario NVARCHAR(100) NOT NULL UNIQUE,
    Correo NVARCHAR(100) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    RolId INT NOT NULL,
    PrimerNombre NVARCHAR(50) NOT NULL,
    ApellidoPaterno NVARCHAR(50) NOT NULL,
    ApellidoMaterno NVARCHAR(50),
    Activo BIT NOT NULL DEFAULT 1,
    UltimoAcceso DATETIME NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Usuarios_Roles FOREIGN KEY (RolId) REFERENCES Roles(RolId)
);

-- Tabla: Propietarios
CREATE TABLE Propietarios (
    PropietarioId INT PRIMARY KEY IDENTITY(1,1),
    Cedula NVARCHAR(20) NOT NULL UNIQUE,
    PrimerNombre NVARCHAR(50) NOT NULL,
    ApellidoPaterno NVARCHAR(50) NOT NULL,
    ApellidoMaterno NVARCHAR(50),
    CorreoElectronico NVARCHAR(100) NOT NULL,
    TelefonoPrincipal NVARCHAR(15) NOT NULL,
    TelefonoSecundario NVARCHAR(15),
    Direccion NVARCHAR(255),
    CiudadResidencia NVARCHAR(50),
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE()
);

-- Tabla: Propiedades
CREATE TABLE Propiedades (
    PropiedadId INT PRIMARY KEY IDENTITY(1,1),
    NumeroCasa NVARCHAR(20) NOT NULL UNIQUE,
    TipoCasa NVARCHAR(50) NOT NULL, -- 'Apartamento', 'Casa', 'Local'
    AreaMetrosCuadrados DECIMAL(10, 2) NOT NULL,
    NumeroHabitaciones INT,
    PropietarioId INT NOT NULL,
    Piso INT,
    Bloque NVARCHAR(10),
    Activa BIT NOT NULL DEFAULT 1,
    FechaCompra DATETIME,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Propiedades_Propietarios FOREIGN KEY (PropietarioId) REFERENCES Propietarios(PropietarioId),
    CONSTRAINT CK_AreaPositiva CHECK (AreaMetrosCuadrados > 0)
);

-- Tabla: Residentes
CREATE TABLE Residentes (
    ResidenteId INT PRIMARY KEY IDENTITY(1,1),
    PropiedadId INT NOT NULL,
    Cedula NVARCHAR(20) NOT NULL,
    PrimerNombre NVARCHAR(50) NOT NULL,
    ApellidoPaterno NVARCHAR(50) NOT NULL,
    ApellidoMaterno NVARCHAR(50),
    TelefonoContacto NVARCHAR(15),
    CorreoElectronico NVARCHAR(100),
    FechaIngreso DATETIME NOT NULL DEFAULT GETDATE(),
    FechaSalida DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Residentes_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId),
    CONSTRAINT UK_Residentes_Cedula UNIQUE(Cedula, PropiedadId)
);

-- Tabla: CargosFacturables
CREATE TABLE CargosFacturables (
    CargoId INT PRIMARY KEY IDENTITY(1,1),
    NombreCargo NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255),
    Monto DECIMAL(10, 2) NOT NULL,
    TipoCargo NVARCHAR(50), -- 'Base', 'Adicional', 'Especial'
    AplicableATodos BIT NOT NULL DEFAULT 1,
    Activo BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_MontoPositivo CHECK (Monto > 0)
);

-- Tabla: Facturas
CREATE TABLE Facturas (
    FacturaId INT PRIMARY KEY IDENTITY(1,1),
    NumeroFactura NVARCHAR(20) NOT NULL UNIQUE,
    PropiedadId INT NOT NULL,
    FechaEmision DATETIME NOT NULL DEFAULT GETDATE(),
    FechaVencimiento DATETIME NOT NULL,
    EstadoFactura NVARCHAR(50) NOT NULL DEFAULT 'Pendiente', -- 'Pendiente', 'Pagada', 'Anulada'
    Subtotal DECIMAL(10, 2) NOT NULL,
    TotalInteres DECIMAL(10, 2) DEFAULT 0,
    TotalRecargo DECIMAL(10, 2) DEFAULT 0,
    TotalFactura DECIMAL(10, 2) NOT NULL,
    Observacion NVARCHAR(500),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Facturas_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId),
    CONSTRAINT CK_TotalFacturaPositivo CHECK (TotalFactura > 0)
);

-- Tabla: DetallesFactura
CREATE TABLE DetallesFactura (
    DetalleId INT PRIMARY KEY IDENTITY(1,1),
    FacturaId INT NOT NULL,
    CargoId INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 1,
    ValorUnitario DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_DetallesFactura_Facturas FOREIGN KEY (FacturaId) REFERENCES Facturas(FacturaId) ON DELETE CASCADE,
    CONSTRAINT FK_DetallesFactura_Cargos FOREIGN KEY (CargoId) REFERENCES CargosFacturables(CargoId),
    CONSTRAINT CK_CantidadPositiva CHECK (Cantidad > 0),
    CONSTRAINT CK_SubtotalPositivo CHECK (Subtotal > 0)
);

-- Tabla: Pagos
CREATE TABLE Pagos (
    PagoId INT PRIMARY KEY IDENTITY(1,1),
    FacturaId INT NOT NULL,
    MontoPagado DECIMAL(10, 2) NOT NULL,
    FechaPago DATETIME NOT NULL DEFAULT GETDATE(),
    FormaPago NVARCHAR(50) NOT NULL, -- 'Efectivo', 'Transferencia', 'Cheque'
    Referencia NVARCHAR(100),
    ResponsableRecibio NVARCHAR(100),
    Observacion NVARCHAR(255),
    CONSTRAINT FK_Pagos_Facturas FOREIGN KEY (FacturaId) REFERENCES Facturas(FacturaId),
    CONSTRAINT CK_MontoPagoPositivo CHECK (MontoPagado > 0)
);

-- Tabla: AreasComunes
CREATE TABLE AreasComunes (
    AreaId INT PRIMARY KEY IDENTITY(1,1),
    NombreArea NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255),
    CapacidadMaxima INT NOT NULL,
    TipoArea NVARCHAR(50), -- 'Salón', 'Piscina', 'Cancha', 'Parque', etc.
    Ubicacion NVARCHAR(255),
    Activa BIT NOT NULL DEFAULT 1,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_CapacidadPositiva CHECK (CapacidadMaxima > 0)
);

-- Tabla: Reservas
CREATE TABLE Reservas (
    ReservaId INT PRIMARY KEY IDENTITY(1,1),
    AreaId INT NOT NULL,
    PropiedadId INT NOT NULL,
    FechaReserva DATETIME NOT NULL,
    HoraInicio TIME NOT NULL,
    HoraFin TIME NOT NULL,
    CantidadPersonas INT NOT NULL,
    EstadoReserva NVARCHAR(50) NOT NULL DEFAULT 'Confirmada', -- 'Confirmada', 'Cancelada', 'Completada'
    ResponsableReserva NVARCHAR(100),
    Observacion NVARCHAR(500),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Reservas_AreasComunes FOREIGN KEY (AreaId) REFERENCES AreasComunes(AreaId),
    CONSTRAINT FK_Reservas_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId),
    CONSTRAINT CK_CantidadPersonasPositiva CHECK (CantidadPersonas > 0),
    CONSTRAINT CK_HorasValidas CHECK (HoraInicio < HoraFin)
);

-- Tabla: Visitas
CREATE TABLE Visitas (
    VisitaId INT PRIMARY KEY IDENTITY(1,1),
    PropiedadId INT NOT NULL,
    NombreVisitante NVARCHAR(100) NOT NULL,
    CedulaVisitante NVARCHAR(20),
    NumeroIdentificacion NVARCHAR(50),
    PlacaVehiculo NVARCHAR(20),
    FechaEntrada DATETIME NOT NULL DEFAULT GETDATE(),
    FechaSalida DATETIME NULL,
    CodigoQR NVARCHAR(100) UNIQUE,
    Proposito NVARCHAR(255),
    Autorizado BIT NOT NULL DEFAULT 1,
    RegistradoPor NVARCHAR(100),
    CONSTRAINT FK_Visitas_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId)
);

-- Tabla: Bitacora (Auditoría)
CREATE TABLE Bitacora (
    BitacoraId BIGINT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT,
    TipoOperacion NVARCHAR(50) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    TablaAfectada NVARCHAR(50) NOT NULL,
    IdRegistro INT,
    ValoresAnteriores NVARCHAR(MAX),
    ValoresNuevos NVARCHAR(MAX),
    FechaOperacion DATETIME NOT NULL DEFAULT GETDATE(),
    DireccionIP NVARCHAR(50),
    CONSTRAINT FK_Bitacora_Usuarios FOREIGN KEY (UsuarioId) REFERENCES Usuarios(UsuarioId)
);

-- Tabla: FondoReserva
CREATE TABLE FondoReserva (
    FondoId INT PRIMARY KEY IDENTITY(1,1),
    PropiedadId INT NOT NULL,
    MontoAsignado DECIMAL(10, 2) NOT NULL,
    MontoDisponible DECIMAL(10, 2) NOT NULL,
    MontoUtilizado DECIMAL(10, 2) NOT NULL DEFAULT 0,
    Proposito NVARCHAR(255),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    UltimaActualizacion DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_FondoReserva_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId),
    CONSTRAINT CK_MontoFondoPositivo CHECK (MontoAsignado >= 0)
);

-- Tabla: IndicadorMorosidad
CREATE TABLE IndicadorMorosidad (
    MorosidadId INT PRIMARY KEY IDENTITY(1,1),
    PropiedadId INT NOT NULL,
    CedulaPropietario NVARCHAR(20) NOT NULL,
    MontoAdeudado DECIMAL(10, 2) NOT NULL DEFAULT 0,
    DiasMora INT NOT NULL DEFAULT 0,
    TasaRiesgo NVARCHAR(50), -- 'Bajo', 'Medio', 'Alto', 'Crítico'
    FechaCalculoMora DATETIME NOT NULL DEFAULT GETDATE(),
    Observacion NVARCHAR(500),
    CONSTRAINT FK_IndicadorMorosidad_Propiedades FOREIGN KEY (PropiedadId) REFERENCES Propiedades(PropiedadId),
    CONSTRAINT CK_DiasMoraNoNegativo CHECK (DiasMora >= 0)
);

-- 3. CREAR ÍNDICES
-- =====================================================

CREATE NONCLUSTERED INDEX IX_Usuarios_UsuarioId_Correo ON Usuarios(UsuarioId, Correo);
CREATE NONCLUSTERED INDEX IX_Propiedades_PropietarioId ON Propiedades(PropietarioId);
CREATE NONCLUSTERED INDEX IX_Residentes_PropiedadId ON Residentes(PropiedadId);
CREATE NONCLUSTERED INDEX IX_Facturas_PropiedadId_Estado ON Facturas(PropiedadId, EstadoFactura);
CREATE NONCLUSTERED INDEX IX_Facturas_FechaVencimiento ON Facturas(FechaVencimiento);
CREATE NONCLUSTERED INDEX IX_DetallesFactura_FacturaId ON DetallesFactura(FacturaId);
CREATE NONCLUSTERED INDEX IX_Pagos_FacturaId ON Pagos(FacturaId);
CREATE NONCLUSTERED INDEX IX_Pagos_FechaPago ON Pagos(FechaPago);
CREATE NONCLUSTERED INDEX IX_Reservas_AreaId_FechaReserva ON Reservas(AreaId, FechaReserva);
CREATE NONCLUSTERED INDEX IX_Visitas_PropiedadId_FechaEntrada ON Visitas(PropiedadId, FechaEntrada);
CREATE NONCLUSTERED INDEX IX_Bitacora_FechaOperacion ON Bitacora(FechaOperacion);
CREATE NONCLUSTERED INDEX IX_IndicadorMorosidad_PropiedadId ON IndicadorMorosidad(PropiedadId);

-- 4. INSERTAR DATOS DE PRUEBA
-- =====================================================

-- Roles
INSERT INTO Roles (NombreRol, Descripcion) VALUES
('Administrador', 'Control total del sistema'),
('Recepcionista', 'Gestión de pagos y visitas'),
('Contador', 'Generación de reportes financieros'),
('Propietario', 'Acceso a información de su propiedad'),
('Residente', 'Acceso limitado a su residencia');

-- Permisos
INSERT INTO Permisos (NombrePermiso, Descripcion, Modulo) VALUES
('Ver_Usuarios', 'Permiso para ver lista de usuarios', 'Seguridad'),
('Crear_Usuario', 'Permiso para crear nuevos usuarios', 'Seguridad'),
('Editar_Usuario', 'Permiso para editar usuarios', 'Seguridad'),
('Ver_Facturas', 'Permiso para ver facturas', 'Facturación'),
('Crear_Factura', 'Permiso para crear facturas', 'Facturación'),
('Ver_Propiedades', 'Permiso para ver propiedades', 'Propiedades'),
('Crear_Propiedad', 'Permiso para crear propiedades', 'Propiedades'),
('Procesar_Pago', 'Permiso para procesar pagos', 'Pagos'),
('Ver_Reportes', 'Permiso para acceder a reportes', 'Reportes');

-- Asignar permisos a roles (Administrador)
INSERT INTO RolPermisos (RolId, PermisoId) 
SELECT 1, PermisoId FROM Permisos; -- Administrador tiene todos

-- Propietarios
INSERT INTO Propietarios (Cedula, PrimerNombre, ApellidoPaterno, ApellidoMaterno, CorreoElectronico, TelefonoPrincipal, Direccion, CiudadResidencia) VALUES
('112030001', 'Juan', 'García', 'Rodríguez', 'juan.garcia@email.com', '87654321', 'Calle Principal 100', 'San José'),
('112030002', 'María', 'López', 'Martinez', 'maria.lopez@email.com', '87654322', 'Avenida Central 200', 'San José'),
('112030003', 'Carlos', 'Martínez', 'Pérez', 'carlos.martinez@email.com', '87654323', 'Calle Secundaria 300', 'San José');

-- Propiedades
INSERT INTO Propiedades (NumeroCasa, TipoCasa, AreaMetrosCuadrados, NumeroHabitaciones, PropietarioId, Piso, Bloque) VALUES
('101', 'Apartamento', 85.5, 2, 1, 1, 'A'),
('102', 'Apartamento', 90.0, 3, 2, 1, 'A'),
('103', 'Apartamento', 75.0, 2, 3, 1, 'B'),
('201', 'Apartamento', 95.5, 3, 1, 2, 'A'),
('301', 'Casa', 150.0, 4, 2, 0, NULL);

-- Residentes
INSERT INTO Residentes (PropiedadId, Cedula, PrimerNombre, ApellidoPaterno, ApellidoMaterno, TelefonoContacto, CorreoElectronico) VALUES
(1, '206040015', 'Pedro', 'García', 'López', '87111111', 'pedro.garcia@email.com'),
(1, '206040016', 'Ana', 'García', 'Morales', '87111112', 'ana.garcia@email.com'),
(2, '206040017', 'Luis', 'López', 'Méndez', '87111113', 'luis.lopez@email.com'),
(3, '206040018', 'Sofia', 'Martínez', 'Ruiz', '87111114', 'sofia.martinez@email.com'),
(4, '206040019', 'Roberto', 'García', 'Ramírez', '87111115', 'roberto.garcia@email.com');

-- Cargos Facturables
INSERT INTO CargosFacturables (NombreCargo, Descripcion, Monto, TipoCargo, AplicableATodos) VALUES
('Cuota Base Mensual', 'Cuota base de administración', 150000, 'Base', 1),
('Mantenimiento de Áreas Comunes', 'Mantenimiento de zonas comunes', 50000, 'Adicional', 1),
('Servicios de Seguridad', 'Personal de seguridad 24 horas', 75000, 'Adicional', 1),
('Reparación Especial', 'Gastos extraordinarios de reparación', 100000, 'Especial', 0),
('Limpieza Extra', 'Servicio adicional de limpieza', 30000, 'Adicional', 0);

-- Facturas
INSERT INTO Facturas (NumeroFactura, PropiedadId, FechaVencimiento, EstadoFactura, Subtotal, TotalInteres, TotalRecargo, TotalFactura) VALUES
('FAC001', 1, DATEADD(DAY, 30, GETDATE()), 'Pendiente', 275000, 0, 0, 275000),
('FAC002', 2, DATEADD(DAY, 30, GETDATE()), 'Pendiente', 275000, 0, 0, 275000),
('FAC003', 1, DATEADD(DAY, -10, GETDATE()), 'Pendiente', 275000, 13750, 0, 288750),
('FAC004', 3, DATEADD(DAY, 30, GETDATE()), 'Pendiente', 275000, 0, 0, 275000),
('FAC005', 4, DATEADD(DAY, 30, GETDATE()), 'Pagada', 275000, 0, 0, 275000);

-- Detalles de Factura
INSERT INTO DetallesFactura (FacturaId, CargoId, Cantidad, ValorUnitario, Subtotal) VALUES
(1, 1, 1, 150000, 150000),
(1, 2, 1, 50000, 50000),
(1, 3, 1, 75000, 75000),
(2, 1, 1, 150000, 150000),
(2, 2, 1, 50000, 50000),
(2, 3, 1, 75000, 75000),
(3, 1, 1, 150000, 150000),
(3, 2, 1, 50000, 50000),
(3, 3, 1, 75000, 75000),
(4, 1, 1, 150000, 150000),
(4, 2, 1, 50000, 50000),
(4, 3, 1, 75000, 75000),
(5, 1, 1, 150000, 150000),
(5, 2, 1, 50000, 50000),
(5, 3, 1, 75000, 75000);

-- Pagos
INSERT INTO Pagos (FacturaId, MontoPagado, FormaPago, Referencia, ResponsableRecibio) VALUES
(5, 275000, 'Transferencia', 'TRF001', 'Recepcionista 1');

-- Areas Comunes
INSERT INTO AreasComunes (NombreArea, Descripcion, CapacidadMaxima, TipoArea, Ubicacion) VALUES
('Salón de Eventos', 'Salón para celebraciones', 100, 'Salón', 'Primer Piso - Bloque Central'),
('Piscina', 'Piscina olímpica con jacuzzi', 50, 'Piscina', 'Zona verde - Sector A'),
('Cancha de Tenis', 'Cancha de tenis profesional', 4, 'Cancha', 'Sector B'),
('Parque Infantil', 'Área recreativa para niños', 30, 'Parque', 'Zona verde - Sector C'),
('Gimnasio', 'Área de ejercicio con equipos', 20, 'Gimnasio', 'Sótano - Bloque A');

-- Reservas
INSERT INTO Reservas (AreaId, PropiedadId, FechaReserva, HoraInicio, HoraFin, CantidadPersonas, ResponsableReserva, EstadoReserva) VALUES
(1, 1, DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), '18:00', '22:00', 50, 'Juan García', 'Confirmada'),
(2, 2, DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), '14:00', '16:00', 25, 'María López', 'Confirmada'),
(3, 3, DATEADD(DAY, 10, CAST(GETDATE() AS DATE)), '09:00', '11:00', 4, 'Carlos Martínez', 'Confirmada');

-- Visitas
INSERT INTO Visitas (PropiedadId, NombreVisitante, CedulaVisitante, NumeroIdentificacion, PlacaVehiculo, CodigoQR, Proposito, Autorizado, RegistradoPor) VALUES
(1, 'Técnico de Reparación', '115950001', 'TECH001', 'ABC123', 'QR001', 'Reparación de tubería', 1, 'Recepcionista 1'),
(2, 'Visitante Juan', '206050001', 'VISIT001', 'XYZ789', 'QR002', 'Visita familiar', 1, 'Recepcionista 1');

-- Fondo de Reserva
INSERT INTO FondoReserva (PropiedadId, MontoAsignado, MontoDisponible, Proposito) VALUES
(1, 500000, 500000, 'Reparaciones y mantenimiento'),
(2, 500000, 500000, 'Reparaciones y mantenimiento'),
(3, 400000, 400000, 'Reparaciones y mantenimiento');

-- Indicador de Morosidad
INSERT INTO IndicadorMorosidad (PropiedadId, CedulaPropietario, MontoAdeudado, DiasMora, TasaRiesgo, Observacion) VALUES
(1, '112030001', 0, 0, 'Bajo', 'Al corriente'),
(2, '112030002', 0, 0, 'Bajo', 'Al corriente'),
(3, '112030003', 13750, 15, 'Medio', 'Factura FAC003 vencida con intereses'),
(4, '112030001', 0, 0, 'Bajo', 'Al corriente');

-- 5. CREAR PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- SP: Generar Facturas Mensuales
CREATE PROCEDURE sp_GenerarFacturasMensuales
    @AñoMes NVARCHAR(7) -- Formato: '2026-07'
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @Conteo INT = 0;
        DECLARE @PropiedadId INT;
        DECLARE @Subtotal DECIMAL(10, 2);
        DECLARE @NumeroFactura NVARCHAR(20);
        DECLARE @FechaVencimiento DATETIME;
        DECLARE @FacturaId INT;
        
        SET @FechaVencimiento = DATEADD(DAY, 30, CAST(GETDATE() AS DATE));
        
        -- Cursor para cada propiedad activa
        DECLARE facturas_cursor CURSOR FOR
        SELECT PropiedadId FROM Propiedades WHERE Activa = 1;
        
        OPEN facturas_cursor;
        FETCH NEXT FROM facturas_cursor INTO @PropiedadId;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Calcular subtotal de cargos aplicables
            SELECT @Subtotal = SUM(Monto)
            FROM CargosFacturables
            WHERE Activo = 1 AND AplicableATodos = 1;
            
            -- Crear número de factura
            SET @NumeroFactura = 'FAC' + FORMAT(GETDATE(), 'yyMMdd') + RIGHT('0000' + CAST(@PropiedadId AS VARCHAR(4)), 4);
            
            -- Insertar factura
            INSERT INTO Facturas (NumeroFactura, PropiedadId, FechaVencimiento, EstadoFactura, Subtotal, TotalFactura)
            VALUES (@NumeroFactura, @PropiedadId, @FechaVencimiento, 'Pendiente', @Subtotal, @Subtotal);
            
            SET @FacturaId = SCOPE_IDENTITY();
            
            -- Insertar detalles
            INSERT INTO DetallesFactura (FacturaId, CargoId, Cantidad, ValorUnitario, Subtotal)
            SELECT @FacturaId, CargoId, 1, Monto, Monto
            FROM CargosFacturables
            WHERE Activo = 1 AND AplicableATodos = 1;
            
            SET @Conteo = @Conteo + 1;
            
            FETCH NEXT FROM facturas_cursor INTO @PropiedadId;
        END;
        
        CLOSE facturas_cursor;
        DEALLOCATE facturas_cursor;
        
        COMMIT TRANSACTION;
        SELECT 'OK' AS Resultado, @Conteo AS FacturasGeneradas;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH;
END;
GO

-- SP: Procesar Pago de Factura
CREATE PROCEDURE sp_ProcesarPagoFactura
    @FacturaId INT,
    @MontoPagado DECIMAL(10, 2),
    @FormaPago NVARCHAR(50),
    @Referencia NVARCHAR(100),
    @ResponsableRecibio NVARCHAR(100)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @EstadoFactura NVARCHAR(50);
        DECLARE @TotalFactura DECIMAL(10, 2);
        DECLARE @PagoPrevio DECIMAL(10, 2) = 0;
        
        -- Obtener datos de la factura
        SELECT @EstadoFactura = EstadoFactura, @TotalFactura = TotalFactura
        FROM Facturas
        WHERE FacturaId = @FacturaId;
        
        -- Validar que factura existe
        IF @FacturaId IS NULL
            THROW 50001, 'Factura no encontrada', 1;
        
        -- Validar que no esté anulada
        IF @EstadoFactura = 'Anulada'
            THROW 50002, 'No se puede pagar una factura anulada', 1;
        
        -- Calcular pagos previos
        SELECT @PagoPrevio = ISNULL(SUM(MontoPagado), 0)
        FROM Pagos
        WHERE FacturaId = @FacturaId;
        
        -- Validar que no exceda el monto
        IF (@PagoPrevio + @MontoPagado) > @TotalFactura
            THROW 50003, 'Monto pagado excede el total de la factura', 1;
        
        -- Registrar el pago
        INSERT INTO Pagos (FacturaId, MontoPagado, FormaPago, Referencia, ResponsableRecibio)
        VALUES (@FacturaId, @MontoPagado, @FormaPago, @Referencia, @ResponsableRecibio);
        
        -- Actualizar estado si está completamente pagada
        IF (@PagoPrevio + @MontoPagado) = @TotalFactura
        BEGIN
            UPDATE Facturas
            SET EstadoFactura = 'Pagada'
            WHERE FacturaId = @FacturaId;
        END;
        
        -- Registrar en bitácora
        INSERT INTO Bitacora (TipoOperacion, TablaAfectada, IdRegistro, ValoresNuevos)
        VALUES ('INSERT', 'Pagos', @FacturaId, 'Monto: ' + CAST(@MontoPagado AS VARCHAR(20)));
        
        COMMIT TRANSACTION;
        SELECT 'OK' AS Resultado, 'Pago registrado exitosamente' AS Mensaje;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH;
END;
GO

-- SP: Calcular Morosidad
CREATE PROCEDURE sp_CalcularMorosidad
AS
BEGIN
    BEGIN TRY
        UPDATE IndicadorMorosidad
        SET
            MontoAdeudado = (
                SELECT ISNULL(SUM(f.TotalFactura - ISNULL((
                    SELECT SUM(MontoPagado) FROM Pagos WHERE FacturaId = f.FacturaId
                ), 0)), 0)
                FROM Facturas f
                WHERE f.PropiedadId = IndicadorMorosidad.PropiedadId
                    AND f.EstadoFactura = 'Pendiente'
                    AND f.FechaVencimiento < GETDATE()
            ),
            DiasMora = (
                SELECT TOP 1 DATEDIFF(DAY, FechaVencimiento, GETDATE())
                FROM Facturas
                WHERE PropiedadId = IndicadorMorosidad.PropiedadId
                    AND EstadoFactura = 'Pendiente'
                    AND FechaVencimiento < GETDATE()
                ORDER BY FechaVencimiento ASC
            ),
            TasaRiesgo = CASE
                WHEN MontoAdeudado = 0 THEN 'Bajo'
                WHEN MontoAdeudado <= 500000 THEN 'Medio'
                WHEN MontoAdeudado <= 1000000 THEN 'Alto'
                ELSE 'Crítico'
            END
        WHERE PropiedadId IN (SELECT PropiedadId FROM Propiedades WHERE Activa = 1);
        
        SELECT 'OK' AS Resultado, 'Morosidad calculada' AS Mensaje;
    END TRY
    BEGIN CATCH
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH;
END;
GO

-- 6. CREAR VISTAS
-- =====================================================

-- Vista: Facturas Pendientes
CREATE VIEW vw_FacturasPendientes AS
SELECT
    f.FacturaId,
    f.NumeroFactura,
    p.NumeroCasa,
    prop.PrimerNombre + ' ' + prop.ApellidoPaterno AS Propietario,
    f.FechaEmision,
    f.FechaVencimiento,
    f.TotalFactura,
    ISNULL(SUM(pag.MontoPagado), 0) AS PagosRealizados,
    f.TotalFactura - ISNULL(SUM(pag.MontoPagado), 0) AS SaldoPendiente,
    DATEDIFF(DAY, f.FechaVencimiento, GETDATE()) AS DíasAtraso
FROM Facturas f
INNER JOIN Propiedades p ON f.PropiedadId = p.PropiedadId
INNER JOIN Propietarios prop ON p.PropietarioId = prop.PropietarioId
LEFT JOIN Pagos pag ON f.FacturaId = pag.FacturaId
WHERE f.EstadoFactura = 'Pendiente'
GROUP BY f.FacturaId, f.NumeroFactura, p.NumeroCasa, prop.PrimerNombre, prop.ApellidoPaterno,
         f.FechaEmision, f.FechaVencimiento, f.TotalFactura;
GO

-- Vista: Morosos
CREATE VIEW vw_Morosos AS
SELECT
    p.PropiedadId,
    p.NumeroCasa,
    prop.Cedula,
    prop.PrimerNombre + ' ' + prop.ApellidoPaterno AS Propietario,
    prop.CorreoElectronico,
    prop.TelefonoPrincipal,
    m.MontoAdeudado,
    m.DiasMora,
    m.TasaRiesgo
FROM IndicadorMorosidad m
INNER JOIN Propiedades p ON m.PropiedadId = p.PropiedadId
INNER JOIN Propietarios prop ON p.PropietarioId = prop.PropietarioId
WHERE m.MontoAdeudado > 0
ORDER BY m.TasaRiesgo DESC, m.MontoAdeudado DESC;
GO

PRINT 'Base de datos creada exitosamente con todas las tablas, índices y procedimientos.';
