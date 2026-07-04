# Diseño Arquitectónico - Principios SOLID y GRASP
## Sistema de Administración de Condominios

### 📋 Información del Documento
- **Versión:** 1.0
- **Fecha:** 2026-07-03
- **Patrón Base:** N-Capas (7 capas)
- **Principios:** SOLID + GRASP

---

## 1. ARQUITECTURA N-CAPAS

### 1.1 Descripción General

La arquitectura está organizada en **7 capas independientes** que se comunican únicamente con la capa adyacente:

```
┌─────────────────────────────────────────┐
│  1. UI (User Interface)                 │  ← CondominioUI (WinForms)
│     • Presentación de datos             │
│     • Interacción con usuario           │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  2. BLL (Business Logic Layer)          │  ← CondominiBLL
│     • Servicios de negocio              │
│     • Validaciones                      │
│     • Reglas de negocio                 │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  3. DAL (Data Access Layer)             │  ← CondominioDAL
│     • Patrón DAO                        │
│     • Acceso a BD                       │
│     • Procedimientos almacenados        │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  4. Entidades (Entities)                │  ← CondominioEntities
│     • Modelos de dominio                │
│     • Clases de negocio                 │
└─────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  5. DTO (Data Transfer Objects)         │  ← CondominioDTO
│     • Transferencia de datos            │
│     • Entre capas                       │
└─────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  6. Interfaces (Contracts)              │  ← CondominioInterfaces
│     • Definición de contratos           │
│     • Inyección de dependencias         │
└─────────────────────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│  7. Utilities (Helpers)                 │  ← CondominioUtils
│     • Funciones comunes                 │
│     • Validadores                       │
│     • Converters                        │
└─────────────────────────────────────────┘
```

### 1.2 Responsabilidades por Capa

| Capa | Responsabilidad | No Responsable |
|------|-----------------|-----------------|
| **UI** | Presentación de datos, captura de entrada | Lógica de negocio, acceso a BD |
| **BLL** | Validaciones, cálculos, reglas | Acceso directo a BD, presentación |
| **DAL** | Acceso a BD, CRUD | Lógica compleja, presentación |
| **Entities** | Representar objetos de negocio | Acceso a BD, presentación |
| **DTO** | Transferencia entre capas | Lógica de negocio |
| **Interfaces** | Contratos de servicios | Implementación |
| **Utilities** | Funciones reutilizables | Lógica específica de negocio |

---

## 2. PRINCIPIOS SOLID

### 2.1 S - Single Responsibility Principle (SRP)

**Definición:** Cada clase debe tener una única razón para cambiar.

#### ✅ Aplicación en el Proyecto:

**Antes (❌ Incorrecto):**
```csharp
public class FacturaService
{
    // Responsabilidad 1: Generar facturas
    public void GenerarFactura(int propiedadId) { }
    
    // Responsabilidad 2: Enviar correos
    public void EnviarFacturasPorCorreo() { }
    
    // Responsabilidad 3: Calcular intereses
    public decimal CalcularIntereses() { }
    
    // Responsabilidad 4: Generar PDF
    public byte[] GenerarPDF() { }
}
```

**Después (✅ Correcto):**
```csharp
// Cada clase tiene UNA responsabilidad
public class FacturaService 
{
    public void GenerarFactura(int propiedadId) { }
}

public class FacturaEmailService
{
    public void EnviarFacturasPorCorreo() { }
}

public class CalculoMorosidadService
{
    public decimal CalcularIntereses(Factura factura) { }
}

public class FacturaPDFService
{
    public byte[] GenerarPDF(Factura factura) { }
}
```

**Justificación:** Si cambian los requisitos de cálculo de intereses, solo modificamos `CalculoMorosidadService`. No afectamos otras funcionalidades.

---

### 2.2 O - Open/Closed Principle (OCP)

**Definición:** Las clases deben estar abiertas para extensión pero cerradas para modificación.

#### ✅ Aplicación:

**Antes (❌ Incorrecto):**
```csharp
public class PagoProcessor
{
    public void ProcesarPago(Pago pago)
    {
        if (pago.FormaPago == "Efectivo")
            // lógica para efectivo
        else if (pago.FormaPago == "Transferencia")
            // lógica para transferencia
        else if (pago.FormaPago == "Cheque")
            // lógica para cheque
    }
}
// Cada nuevo medio de pago requiere modificar esta clase ❌
```

**Después (✅ Correcto):**
```csharp
// Interfaz base
public interface IProcesadorPago
{
    void Procesar(Pago pago);
}

// Implementaciones específicas
public class ProcesadorPagoEfectivo : IProcesadorPago
{
    public void Procesar(Pago pago) { }
}

public class ProcesadorPagoTransferencia : IProcesadorPago
{
    public void Procesar(Pago pago) { }
}

// Nuevo medio de pago sin modificar existentes ✅
public class ProcesadorPagoTarjeta : IProcesadorPago
{
    public void Procesar(Pago pago) { }
}

// Factory pattern
public class PagoProcessorFactory
{
    public IProcesadorPago ObtenerProcesador(string formaPago)
    {
        return formaPago switch
        {
            "Efectivo" => new ProcesadorPagoEfectivo(),
            "Transferencia" => new ProcesadorPagoTransferencia(),
            "Tarjeta" => new ProcesadorPagoTarjeta(),
            _ => throw new Exception("Forma de pago no soportada")
        };
    }
}
```

**Justificación:** Agregar nuevas formas de pago no requiere modificar código existente, solo extender.

---

### 2.3 L - Liskov Substitution Principle (LSP)

**Definición:** Los objetos derivados deben ser substituibles por sus clases base.

#### ✅ Aplicación:

**Antes (❌ Incorrecto):**
```csharp
public class Residencia
{
    public virtual decimal CalcularCuota() { return 100; }
}

public class Apartamento : Residencia
{
    // Override sin mantener el contrato
    public override decimal CalcularCuota() { return -50; } // ❌ Valor negativo incorrecto
}
```

**Después (✅ Correcto):**
```csharp
public abstract class Residencia
{
    // Contrato explícito
    /// <summary>
    /// Calcula la cuota base de la propiedad
    /// </summary>
    /// <returns>Valor siempre positivo</returns>
    public abstract decimal CalcularCuota();
}

public class Apartamento : Residencia
{
    public override decimal CalcularCuota()
    {
        // Mantiene el contrato del padre
        return 150; // ✅ Valor positivo válido
    }
}

public class Casa : Residencia
{
    public override decimal CalcularCuota()
    {
        return 200; // ✅ Valor positivo válido
    }
}

// Uso polimórfico seguro
public class CuotaCalculador
{
    public decimal CalcularTotal(List<Residencia> propiedades)
    {
        return propiedades.Sum(p => p.CalcularCuota()); // ✅ Funciona con cualquier derivada
    }
}
```

**Justificación:** Podemos usar cualquier derivada de `Residencia` sin sorpresas. El contrato se mantiene.

---

### 2.4 I - Interface Segregation Principle (ISP)

**Definición:** Los clientes no deben depender de interfaces que no usan.

#### ✅ Aplicación:

**Antes (❌ Incorrecto):**
```csharp
// Interfaz gorda
public interface IRepositorio
{
    void Crear(object obj);
    void Actualizar(object obj);
    void Eliminar(int id);
    void Leer(int id);
    void Generar PDF(int id); // No todos los repositorios generan PDF
    void EnviarCorreo(string email); // No todos envían correos
    void CalcularIntereses(); // No todos calculan intereses
}

// Clase que no necesita toda la interfaz ❌
public class RepositorioResidente : IRepositorio
{
    public void Generar PDF(int id) => throw new NotImplementedException();
    public void EnviarCorreo(string email) => throw new NotImplementedException();
    public void CalcularIntereses() => throw new NotImplementedException();
}
```

**Después (✅ Correcto):**
```csharp
// Interfaces segregadas y específicas
public interface IRepositorioCRUD<T>
{
    void Crear(T obj);
    void Actualizar(T obj);
    void Eliminar(int id);
    T Leer(int id);
}

public interface IGeneradorPDF
{
    byte[] GenerarPDF(int id);
}

public interface INotificador
{
    void EnviarCorreo(string email);
}

public interface ICalculadorIntereses
{
    decimal Calcular(decimal monto, int dias);
}

// Ahora cada clase implementa solo lo que necesita ✅
public class RepositorioResidente : IRepositorioCRUD<Residente>
{
    public void Crear(Residente obj) { }
    public void Actualizar(Residente obj) { }
    public void Eliminar(int id) { }
    public Residente Leer(int id) { }
}

// Otras clases heredan funcionalidades específicas
public class GeneradorFactura : IGeneradorPDF
{
    public byte[] GenerarPDF(int id) { }
}
```

**Justificación:** Cada clase solo depende de lo que realmente usa. Mayor flexibilidad y menor acoplamiento.

---

### 2.5 D - Dependency Inversion Principle (DIP)

**Definición:** Depender de abstracciones, no de implementaciones concretas.

#### ✅ Aplicación:

**Antes (❌ Incorrecto):**
```csharp
// Alta dependencia de implementación concreta
public class FacturaService
{
    private SqlServerRepositorio _repo; // ❌ Acoplado a SqlServer
    
    public FacturaService()
    {
        _repo = new SqlServerRepositorio(); // ❌ Creación acoplada
    }
    
    public void GenerarFactura(int propiedadId)
    {
        _repo.GuardarFactura(...);
    }
}
// Si queremos cambiar a MySQL, debemos modificar toda la clase ❌
```

**Después (✅ Correcto):**
```csharp
// Depender de abstracción
public interface IRepositorioFactura
{
    void Guardar(Factura factura);
    Factura Obtener(int id);
}

public class SqlServerRepositorioFactura : IRepositorioFactura
{
    public void Guardar(Factura factura) { /* SQL Server */ }
    public Factura Obtener(int id) { /* SQL Server */ }
}

public class FacturaService
{
    private readonly IRepositorioFactura _repo; // ✅ Depende de interfaz
    
    // Inyección de dependencia
    public FacturaService(IRepositorioFactura repo)
    {
        _repo = repo ?? throw new ArgumentNullException(nameof(repo));
    }
    
    public void GenerarFactura(int propiedadId)
    {
        _repo.Guardar(...);
    }
}

// Uso flexible ✅
var repoSQL = new SqlServerRepositorioFactura();
var servicioSQL = new FacturaService(repoSQL);

// Cambiar a otra BD sin modificar código ✅
var repoMySQL = new MySQLRepositorioFactura();
var servicioMySQL = new FacturaService(repoMySQL);

// Para pruebas, usar mock ✅
var repoMock = new MockRepositorioFactura();
var servicioPrueba = new FacturaService(repoMock);
```

**Justificación:** Cambiar de BD, agregar nuevas implementaciones, o hacer testing es trivial.

---

## 3. PRINCIPIOS GRASP

### 3.1 Information Expert

**Definición:** La responsabilidad debe asignarse a la clase que tiene la información.

#### ✅ Aplicación:

```csharp
// ✅ Correcto: Factura calcula su propio total (tiene la información)
public class Factura
{
    public List<DetalleFactura> Detalles { get; set; }
    
    public decimal ObtenerTotal()
    {
        return Detalles.Sum(d => d.SubTotal);
    }
}

// ❌ Incorrecto: Servicio calcula lo que Factura sabe
public class FacturaCalculador
{
    public decimal ObtenerTotal(Factura factura)
    {
        return factura.Detalles.Sum(d => d.SubTotal);
    }
}
```

### 3.2 Creator

**Definición:** La clase que crea un objeto debe ser la que tiene la información para hacerlo.

#### ✅ Aplicación:

```csharp
// ✅ Correcto: Propiedad crea DetalleFactura (tiene la información)
public class Propiedad
{
    public DetalleFactura CrearDetalle(CargFacturable cargo)
    {
        return new DetalleFactura
        {
            CargFacturable = cargo,
            Monto = cargo.Valor,
            Cantidad = 1
        };
    }
}

// ❌ Incorrecto: Servicio crea lo que Propiedad sabe hacer
public class FacturaService
{
    public DetalleFactura CrearDetalle(Propiedad propiedad, CargFacturable cargo)
    {
        // Lógica que Propiedad debería conocer
    }
}
```

### 3.3 Controller

**Definición:** Un objeto "controlador" debe manejar eventos del sistema.

#### ✅ Aplicación:

```csharp
// ✅ Correcto: Controlador maneja la lógica de flujo
public class FacturaController
{
    private readonly IFacturaService _facturaService;
    
    public FacturaController(IFacturaService facturaService)
    {
        _facturaService = facturaService;
    }
    
    public void GenerarFacturasMensuales()
    {
        _facturaService.Generar();
        // Delega al servicio, no hace lógica
    }
}
```

### 3.4 Low Coupling

**Definición:** Minimizar dependencias entre clases.

#### ✅ Aplicación:

```csharp
// ❌ Alto acoplamiento
public class PagoService
{
    private FacturaService _facturaService = new(); // Acoplamiento directo
    private ReportService _reportService = new(); // Acoplamiento directo
}

// ✅ Bajo acoplamiento
public class PagoService
{
    private readonly IFacturaService _facturaService;
    private readonly IReportService _reportService;
    
    public PagoService(IFacturaService fs, IReportService rs)
    {
        _facturaService = fs;
        _reportService = rs;
    }
}
```

### 3.5 High Cohesion

**Definición:** Los elementos relacionados deben estar juntos en una clase.

#### ✅ Aplicación:

```csharp
// ✅ Alta cohesión: Métodos relacionados en una clase
public class CalculoMorosidad
{
    public decimal CalcularInteres(decimal monto, int diasAtraso) { }
    public decimal CalcularRecargo(decimal monto) { }
    public decimal CalcularTotalAdeudado(Factura factura) { }
}

// ❌ Baja cohesión: Métodos sin relación en una clase
public class MiscService
{
    public void EnviarCorreo() { }
    public void CalcularInteres() { }
    public void GenerarPDF() { }
    public void CrearUsuario() { }
}
```

---

## 4. PATRONES DE DISEÑO IMPLEMENTADOS

### 4.1 Data Access Object (DAO)

```csharp
public interface IFacturaDAO
{
    void Insertar(Factura factura);
    Factura ObtenerPorId(int id);
    List<Factura> ObtenerPendientes();
    void Actualizar(Factura factura);
}

public class FacturaDAO : IFacturaDAO
{
    private readonly string _connectionString;
    
    public void Insertar(Factura factura)
    {
        using (SqlConnection conn = new(_connectionString))
        {
            // Acceso directo a BD
        }
    }
}
```

### 4.2 Data Transfer Object (DTO)

```csharp
// Entidad de negocio
public class Factura
{
    public int Id { get; set; }
    public Propiedad Propiedad { get; set; }
    public List<DetalleFactura> Detalles { get; set; }
}

// DTO para transferencia entre capas
public class FacturaDTO
{
    public int Id { get; set; }
    public int PropiedadId { get; set; }
    public decimal Total { get; set; }
}
```

### 4.3 Factory Pattern

```csharp
public interface IProcesadorPago
{
    void Procesar(Pago pago);
}

public class PagoProcessorFactory
{
    public IProcesadorPago ObtenerProcesador(string tipo)
    {
        return tipo switch
        {
            "Efectivo" => new ProcesadorEfectivo(),
            "Transferencia" => new ProcesadorTransferencia(),
            "Cheque" => new ProcesadorCheque(),
            _ => throw new InvalidOperationException()
        };
    }
}
```

### 4.4 Singleton Pattern

```csharp
public class ConfiguracionApp
{
    private static ConfiguracionApp _instancia;
    private static readonly object _lock = new();
    
    private ConfiguracionApp() { }
    
    public static ConfiguracionApp ObtenerInstancia()
    {
        if (_instancia == null)
        {
            lock (_lock)
            {
                if (_instancia == null)
                {
                    _instancia = new ConfiguracionApp();
                }
            }
        }
        return _instancia;
    }
    
    public string ObtenerConnectionString() { }
}
```

---

## 5. JUSTIFICACIÓN ARQUITECTÓNICA

### ¿Por qué N-Capas?

| Ventaja | Justificación |
|---------|---------------|
| **Modularidad** | Cada capa tiene responsabilidad clara |
| **Mantenibilidad** | Cambios localizados en una capa |
| **Escalabilidad** | Fácil agregar nuevas funcionalidades |
| **Testing** | Cada capa puede testearse independientemente |
| **Reutilización** | Capas inferiores usables por diferentes UIs |
| **Seguridad** | Validaciones en múltiples niveles |

### Validación de Principios Aplicados

| Principio | Implementación | Beneficio |
|-----------|----------------|-----------|
| **SRP** | Servicios especializados | Fácil mantenimiento |
| **OCP** | Interfaces y herencia | Extensible sin modificar |
| **LSP** | Polimorfismo correcto | Intercambiabilidad |
| **ISP** | Interfaces pequeñas | Menos dependencias |
| **DIP** | Inyección de dependencias | Flexible y testeable |

---

**Documento versión 1.0**
