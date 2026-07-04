# Requerimientos Funcionales y No Funcionales
## Sistema de Administración de Condominios - ISW-524

### 📋 Información del Documento
- **Versión:** 1.0
- **Fecha:** 2026-07-03
- **Responsable:** Kendall & Colaborador
- **Estado:** En Desarrollo

---

## 1️⃣ REQUERIMIENTOS FUNCIONALES (RF)

### 1.1 Módulo de Usuarios y Autenticación

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-001 | El sistema debe autenticar usuarios con correo y contraseña cifrada | ALTA |
| RF-002 | El sistema debe registrar intentos fallidos de acceso | ALTA |
| RF-003 | El sistema debe validar sesiones activas | ALTA |
| RF-004 | El sistema debe permitir cambio de contraseña seguro | ALTA |
| RF-005 | El sistema debe recuperar contraseña mediante correo de verificación | MEDIA |
| RF-006 | El sistema debe asignar roles predefinidos a usuarios | ALTA |
| RF-007 | El sistema debe registrar permisos específicos por rol | ALTA |
| RF-008 | El sistema debe cerrar sesión correctamente | ALTA |

### 1.2 Módulo de Gestión de Propiedades

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-009 | Crear nuevas propiedades con datos básicos (dirección, área, tipo) | ALTA |
| RF-010 | Actualizar información de propiedades existentes | ALTA |
| RF-011 | Eliminar propiedades del sistema (soft delete) | MEDIA |
| RF-012 | Listar todas las propiedades con paginación | ALTA |
| RF-013 | Buscar propiedades por número, ubicación o propietario | ALTA |
| RF-014 | Asignar propietarios a propiedades | ALTA |
| RF-015 | Registrar múltiples residentes por propiedad | ALTA |
| RF-016 | Calcular áreas de propiedades automáticamente | MEDIA |

### 1.3 Módulo de Gestión de Residentes y Propietarios

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-017 | Registrar nuevos propietarios con datos personales | ALTA |
| RF-018 | Registrar nuevos residentes y asociarlos a propiedades | ALTA |
| RF-019 | Mantener histórico de residentes | MEDIA |
| RF-020 | Actualizar datos de contacto de propietarios/residentes | ALTA |
| RF-021 | Validar número de cédula único por propietario | ALTA |
| RF-022 | Generar reporte de ocupación de propiedades | MEDIA |

### 1.4 Módulo de Facturación

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-023 | Crear concepto de cargo facturable (cuota base, mantenimiento, etc) | ALTA |
| RF-024 | Generar automáticamente facturas mensuales para todas las propiedades | ALTA |
| RF-025 | Calcular intereses por mora automáticamente | ALTA |
| RF-026 | Aplicar recargos por pago tardío | MEDIA |
| RF-027 | Generar facturas individuales por propiedad | ALTA |
| RF-028 | Visualizar detalle de facturas (conceptos, montos, fechas) | ALTA |
| RF-029 | Anular facturas con justificación | MEDIA |
| RF-030 | Generar recibos de facturación | ALTA |
| RF-031 | Exportar facturas en formato PDF | ALTA |
| RF-032 | Enviar facturas por correo a propietarios | MEDIA |

### 1.5 Módulo de Pagos

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-033 | Registrar pagos parciales o totales de facturas | ALTA |
| RF-034 | Validar que pago coincida con facturas pendientes | ALTA |
| RF-035 | Generar recibos de pago | ALTA |
| RF-036 | Aplicar pagos a facturas más antiguas primero (FIFO) | MEDIA |
| RF-037 | Registrar diferentes formas de pago (efectivo, transferencia, cheque) | ALTA |
| RF-038 | Generar reporte de pagos por período | MEDIA |

### 1.6 Módulo de Reservas de Áreas Comunes

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-039 | Registrar áreas comunes (salón, piscina, cancha, etc) | ALTA |
| RF-040 | Crear reservas de áreas comunes por propietarios | ALTA |
| RF-041 | Validar disponibilidad de áreas en fechas solicitadas | ALTA |
| RF-042 | Cancelar reservas con notificación | MEDIA |
| RF-043 | Generar calendario de ocupación por área | MEDIA |
| RF-044 | Validar capacidad máxima de áreas comunes | ALTA |

### 1.7 Módulo de Control de Acceso (Visitantes)

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-045 | Registrar visitantes con datos personales | ALTA |
| RF-046 | Generar códigos QR para visitantes | MEDIA |
| RF-047 | Validar entrada/salida de visitantes | ALTA |
| RF-048 | Registrar horarios de acceso | ALTA |
| RF-049 | Alertar sobre visitantes no autorizados | MEDIA |

### 1.8 Módulo de Reportes

| Código | Descripción | Prioridad |
|--------|-------------|-----------|
| RF-050 | Generar reporte de ingresos por período | ALTA |
| RF-051 | Generar reporte de morosidad | ALTA |
| RF-052 | Generar reporte de ocupación | MEDIA |
| RF-053 | Generar reporte de reservas realizadas | MEDIA |
| RF-054 | Generar reporte de acceso de visitantes | MEDIA |
| RF-055 | Exportar reportes en PDF y Excel | ALTA |

---

## 2️⃣ REQUERIMIENTOS NO FUNCIONALES (RNF)

### 2.1 Rendimiento y Eficiencia

| Código | Descripción | Métrica |
|--------|-------------|---------|
| RNF-001 | Tiempo de respuesta en consultas: máximo 2 segundos | 2 seg |
| RNF-002 | Tiempo de generación de facturas masivas: máximo 5 minutos para 500 facturas | 5 min |
| RNF-003 | Capacidad de procesamiento: mínimo 1000 transacciones concurrentes | 1000 tx |

### 2.2 Seguridad

| Código | Descripción | Implementación |
|--------|-------------|-----------------|
| RNF-004 | Contraseñas deben estar cifradas (SHA256 o superior) | SHA256+ |
| RNF-005 | Implementar validación de roles y permisos en cada operación | RBAC |
| RNF-006 | Registrar todas las operaciones en bitácora de auditoría | Audit Log |
| RNF-007 | Validar inputs contra inyección SQL | Parameterized Queries |
| RNF-008 | Implementar bloqueo de cuenta después de 5 intentos fallidos | 5 intentos |

### 2.3 Disponibilidad

| Código | Descripción | Objetivo |
|--------|-------------|----------|
| RNF-009 | Disponibilidad del sistema: 99.5% uptime | 99.5% |
| RNF-010 | Backup automático diario de la base de datos | Diariamente |
| RNF-011 | Plan de recuperación ante desastres | RTO 4h |

### 2.4 Escalabilidad

| Código | Descripción | Capacidad |
|--------|-------------|-----------|
| RNF-012 | Soportar mínimo 500 usuarios concurrentes | 500 users |
| RNF-013 | Base de datos debe soportar 100,000 registros sin degradación | 100k reg |
| RNF-014 | Arquitectura modular para facilitar expansión futura | Modular |

### 2.5 Confiabilidad y Mantenibilidad

| Código | Descripción | Requerimiento |
|--------|-------------|-----------------|
| RNF-015 | Código debe cumplir principios SOLID | Obligatorio |
| RNF-016 | Documentación de componentes arquitectónicos | Documentado |
| RNF-017 | Pruebas unitarias para lógica de negocio | >= 80% cobertura |
| RNF-018 | Código debe ser facilmente mantenible | Code Review |

### 2.6 Usabilidad

| Código | Descripción | Requerimiento |
|--------|-------------|-----------------|
| RNF-019 | Interfaz intuitiva y amigable | UI/UX Review |
| RNF-020 | Mensajes de error claros en español | Bilingüe |
| RNF-021 | Respuesta rápida a acciones de usuario | < 1 seg |

---

## 3️⃣ GLOSARIO DE TÉRMINOS

| Término | Definición |
|---------|-----------|
| **Propiedad** | Unidad inmobiliaria (apartamento, casa, local) dentro del condominio |
| **Propietario** | Persona que es dueña de una o más propiedades |
| **Residente** | Persona que habita una propiedad (puede no ser el propietario) |
| **Cuota Base** | Monto mensual fijo que paga cada propiedad para gastos comunes |
| **Cargo Facturable** | Concepto de cobro adicional a la cuota base (servicios especiales) |
| **Morosidad** | Condición de haber incumplido con pagos de facturas |
| **Interés Moratorio** | Porcentaje de interés aplicado a facturas atrasadas |
| **Área Común** | Espacio compartido por todos los residentes (piscina, salón, etc) |
| **Reserva** | Solicitud de uso de área común por un residente en fecha específica |
| **Bitácora** | Registro histórico de todas las operaciones del sistema |
| **QR** | Código de respuesta rápida para control de acceso de visitantes |
| **Rol** | Conjunto de permisos asignado a usuarios del sistema |
| **Permiso** | Autorización específica para realizar una acción en el sistema |
| **DTO** | Data Transfer Object - objeto para transferencia de datos entre capas |
| **DAO** | Data Access Object - objeto para acceso a datos en BD |
| **Stored Procedure** | Procedimiento almacenado en SQL Server para operaciones específicas |
| **Transacción** | Conjunto de operaciones que se ejecutan juntas en BD |

---

## 4️⃣ CASOS DE USO PRINCIPALES

### Caso de Uso 1: Generar Facturas Mensuales

**Nombre:** Generar Facturas Mensuales del Condominio

**Actores Primarios:** Administrador del Sistema

**Actores Secundarios:** Sistema de Correos, Base de Datos

**Precondiciones:**
- Sistema debe tener acceso a la BD
- Debe haber propiedades registradas
- Debe haber cargos facturables configurados

**Flujo Principal:**
1. Administrador selecciona opción "Generar Facturas" desde menú
2. Sistema valida que no existan facturas ya generadas para el mes actual
3. Sistema obtiene lista de propiedades activas
4. Para cada propiedad:
   - Obtiene cargos facturables aplicables
   - Calcula morosidad de meses anteriores
   - Aplica intereses moratorios si aplica
   - Crea registro de factura
   - Genera detalles de factura por cada cargo
5. Sistema muestra resumen de facturas generadas

**Postcondiciones:**
- Todas las facturas han sido registradas en BD
- Cada factura tiene al menos la cuota base
- Se ha generado bitácora de operación

---

### Caso de Uso 2: Procesar Pago de Factura

**Nombre:** Procesar Pago de Factura Pendiente

**Actores Primarios:** Recepcionista del Condominio

**Flujo Principal:**
1. Recepcionista ingresa número de factura o cédula del propietario
2. Sistema valida y muestra facturas pendientes
3. Recepcionista ingresa monto pagado y forma de pago
4. Sistema valida que monto sea válido
5. Sistema aplica pago a facturas más antiguas (FIFO)
6. Sistema genera recibo de pago
7. Sistema actualiza estado de facturas

**Postcondiciones:**
- Factura(s) actualizada(s) con saldo pendiente
- Recibo generado e impreso/enviado

---

## 📋 Matriz de Trazabilidad

| RF | RNF | Componente | Prioridad |
|----|-----|-----------|-----------|
| RF-001,002,003 | RNF-004,006,008 | Auth Module | ALTA |
| RF-023-032 | RNF-001,002 | Billing Module | ALTA |
| RF-050-055 | RNF-001,003 | Reporting Module | MEDIA |

---

**Documento versión 1.0 - Disponible en docs/Avance1/Análisis/**
