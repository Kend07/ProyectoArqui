# 🏢 Sistema de Administración de Condominios
## Proyecto Aplicado - ISW-524 Diseño de Arquitectura de Software

### 📋 Información General
- **Carrera:** Ingeniería del Software (ISW)
- **Curso:** ISW-524 - Diseño de Arquitectura de Software
- **Período:** II - 2026
- **Grupo:** 02 - Lunes 
- **Profesor:** Mgt. Karlinna Chaves González
- **Estudiantes:** Kendall & Colaborador

### 🎯 Objetivo
Diseñar e implementar un **sistema completo de administración de condominios** aplicando principios sólidos de **Arquitectura de Software**, patrones de diseño y buenas prácticas de desarrollo en **C# con .NET Framework 4.8**.

### 📊 Alcance del Proyecto
- **Gestión de Propiedades:** Registro, actualización, eliminación
- **Gestión de Residentes y Propietarios:** Control de ocupantes
- **Sistema de Facturación Electrónica:** Generación automática de cuotas
- **Cálculo de Morosidad:** Intereses y penalizaciones automáticas
- **Reservas de Áreas Comunes:** Validación de disponibilidad
- **Control de Acceso:** Registro de visitas con QR
- **Seguridad:** Roles, permisos, auditoría
- **Reportes Financieros:** Análisis de ingresos y morosidad

### 🏗️ Arquitectura
```
┌─────────────────────────────────────────┐
│        INTERFAZ DE USUARIO (UI)         │
│         WinForms - Windows Forms        │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│    LÓGICA DE NEGOCIO (BLL)              │
│   • Servicios de facturación            │
│   • Cálculos financieros                │
│   • Validaciones de negocio             │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│    ACCESO A DATOS (DAL)                 │
│   • DAO Pattern                         │
│   • Procedimientos almacenados          │
│   • Transacciones                       │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│    SQL SERVER 2022                      │
│   • Base de datos relacional            │
│   • 16 tablas normalizadas (3FN)        │
│   • Índices optimizados                 │
└─────────────────────────────────────────┘
```

### 🛠️ Tecnologías Utilizadas
- **Lenguaje:** C# (.NET Framework 4.8)
- **IDE:** Visual Studio 2022 Community
- **Interfaz:** WinForms
- **Base de Datos:** SQL Server 2022 Express
- **Modelado UML:** StarUML
- **Versionamiento:** Git + GitHub
- **Documentación:** Markdown + PDF

### 📂 Estructura del Repositorio
```
ProyectoArqui/
│
├── README.md                              # Este archivo
├── .gitignore                             # Archivos a ignorar en Git
│
├── src/                                   # Código fuente
│   ├── CondominioUI/                      # Presentación (WinForms)
│   ├── CondominiBLL/                      # Lógica de negocio
│   ├── CondominioDAL/                     # Acceso a datos
│   ├── CondominioEntities/                # Modelos de dominio
│   ├── CondominioDTO/                     # Transferencia de datos
│   ├── CondominioInterfaces/              # Interfaces/Contratos
│   └── CondominioUtils/                   # Utilidades generales
│
├── docs/                                  # Documentación
│   ├── Avance1/
│   │   ├── Análisis/
│   │   ├── Arquitectura/
│   │   ├── UML/
│   │   ├── BaseDatos/
│   │   └── Avance1.pdf
│   ├── Avance2/
│   ├── Avance3/
│   └── Avance4/
│
├── scripts/                               # Scripts SQL
│   ├── CreateDatabase.sql                 # Crear BD + tablas
│   ├── InsertDataPrueba.sql               # Datos de prueba
│   └── StoredProcedures.sql               # Procedimientos almacenados
│
└── CondominioSolution.sln                 # Solución Visual Studio
```

### 📅 Cronograma de Entregas
| Avance | Descripción | Valor | Semana | Estado |
|--------|------------|-------|--------|--------|
| **1** | Análisis y Diseño Arquitectónico | 8% | #7 | ⏳ En Proceso |
| **2** | Implementación BLL | 10% | #10 | ⏸️ Pendiente |
| **3** | Implementación DAL + BD | 9% | #11 | ⏸️ Pendiente |
| **4** | UI + Reportes + Integración | 8% | #12 | ⏸️ Pendiente |
| **Defensa** | Presentación Final | 35% | #14 | ⏸️ Pendiente |

### 👥 Integrantes del Proyecto
- **Kendall** - Análisis y Diseño
- **Colaborador** - Implementación y Desarrollo

### 🚀 Cómo Clonar y Usar
```bash
# Clonar el repositorio
git clone https://github.com/Kend07/ProyectoArqui
cd ProyectoArqui

# Abrir la solución
# Abrir CondominioSolution.sln con Visual Studio 2022

# Crear la base de datos
# Ejecutar scripts/CreateDatabase.sql en SQL Server Management Studio

# Compilar la solución
# Ctrl + Shift + B en Visual Studio
```

### 📚 Principios de Arquitectura Aplicados
- ✅ **N-Capas:** Separación clara de responsabilidades
- ✅ **SOLID:** Single Responsibility, Open/Closed, Liskov, Interface Segregation, Dependency Inversion
- ✅ **GRASP:** Controller, Creator, Information Expert, Low Coupling, High Cohesion
- ✅ **Patrones de Diseño:**
  - DAO (Data Access Object)
  - DTO (Data Transfer Object)
  - Factory
  - Facade
  - Singleton

### 📖 Documentación Requerida
- [x] Análisis de Requerimientos (RF + RNF)
- [x] Diseño Arquitectónico documentado
- [x] Diagramas UML (Casos de uso, Clases, Componentes, Paquetes)
- [x] Modelo 4+1 (Vistas Lógica, Procesos, Física, Desarrollo, Escenarios)
- [x] Modelo Entidad-Relación (MER)
- [x] Diccionario de Datos
- [x] Script SQL de creación de BD
- [x] Justificación de Normalización (1FN, 2FN, 3FN)

### 🔧 Herramientas Necesarias
- [Visual Studio 2022 Community](https://visualstudio.microsoft.com/downloads/) (Gratis)
- [SQL Server 2022 Express](https://www.microsoft.com/es-es/sql-server/sql-server-downloads) (Gratis)
- [SQL Server Management Studio](https://learn.microsoft.com/es-es/sql/ssms/download-sql-server-management-studio-ssms) (Gratis)
- [StarUML](https://staruml.io/) (Demo o Licencia)
- [Git](https://git-scm.com/) (Gratis)

### 📝 Commits Realizados
```
✓ Initial project setup
✓ Add project structure
✓ Create class libraries
✓ Add Entities base classes
✓ Add Data Access Object pattern
✓ Add interfaces and contracts
✓ Add utility classes
✓ Add database script
```

### 📞 Contacto y Soporte
En caso de duda, revisar:
- Documento del proyecto (adjunto en enunciado)
- Especificaciones de arquitectura en `/docs/`
- Documentación en el código (comentarios XML)

---
**Última actualización:** 2026-07-03
**Estado:** En desarrollo - Avance 1 en proceso
