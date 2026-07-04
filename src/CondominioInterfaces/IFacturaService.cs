using System;
using System.Collections.Generic;
using CondominioEntities;

namespace CondominioInterfaces
{
    /// <summary>
    /// Interfaz para operaciones de Factura en la capa de negocio
    /// </summary>
    public interface IFacturaService
    {
        /// <summary>
        /// Genera las facturas mensuales para todas las propiedades
        /// </summary>
        void GenerarFacturasMensuales(string mesAño);

        /// <summary>
        /// Obtiene una factura por ID
        /// </summary>
        Factura ObtenerFactura(int facturaId);

        /// <summary>
        /// Obtiene todas las facturas pendientes de una propiedad
        /// </summary>
        List<Factura> ObtenerFacturasPendientes(int propiedadId);

        /// <summary>
        /// Registra un pago para una factura
        /// </summary>
        void RegistrarPago(int facturaId, decimal montoPagado, string formaPago);

        /// <summary>
        /// Calcula los intereses moratorios de una factura
        /// </summary>
        decimal CalcularIntereses(Factura factura);
    }
}
