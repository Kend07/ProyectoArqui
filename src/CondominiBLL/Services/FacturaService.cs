using System;
using System.Collections.Generic;
using CondominioEntities;
using CondominioInterfaces;

namespace CondominiBLL
{
    /// <summary>
    /// Servicio de negocios para operaciones con Facturas
    /// Implementa la lógica de negocio aplicando principios SOLID
    /// </summary>
    public class FacturaService : IFacturaService
    {
        private readonly IFacturaDAO _facturaDAO;

        /// <summary>
        /// Constructor con inyección de dependencia
        /// Aplicación del principio DIP: Depende de la abstracción IFacturaDAO
        /// </summary>
        public FacturaService(IFacturaDAO facturaDAO)
        {
            _facturaDAO = facturaDAO ?? throw new ArgumentNullException(nameof(facturaDAO));
        }

        /// <summary>
        /// Genera las facturas mensuales para todas las propiedades activas
        /// </summary>
        public void GenerarFacturasMensuales(string mesAño)
        {
            // Validar formato de mes
            if (string.IsNullOrEmpty(mesAño) || mesAño.Length != 7)
                throw new ArgumentException("El mes debe estar en formato yyyy-MM");

            // Aquí va la lógica para generar facturas
            // Por ahora es un placeholder
        }

        /// <summary>
        /// Obtiene una factura por ID
        /// </summary>
        public Factura ObtenerFactura(int facturaId)
        {
            if (facturaId <= 0)
                throw new ArgumentException("El ID de la factura debe ser mayor a 0");

            return _facturaDAO.ObtenerPorId(facturaId);
        }

        /// <summary>
        /// Obtiene todas las facturas pendientes de una propiedad
        /// </summary>
        public List<Factura> ObtenerFacturasPendientes(int propiedadId)
        {
            if (propiedadId <= 0)
                throw new ArgumentException("El ID de la propiedad debe ser mayor a 0");

            return _facturaDAO.ObtenerPendientes(propiedadId);
        }

        /// <summary>
        /// Registra un pago para una factura
        /// </summary>
        public void RegistrarPago(int facturaId, decimal montoPagado, string formaPago)
        {
            if (facturaId <= 0)
                throw new ArgumentException("El ID de la factura debe ser válido");

            if (montoPagado <= 0)
                throw new ArgumentException("El monto pagado debe ser mayor a 0");

            if (string.IsNullOrEmpty(formaPago))
                throw new ArgumentException("La forma de pago es requerida");

            // Obtener la factura
            var factura = ObtenerFactura(facturaId);
            if (factura == null)
                throw new InvalidOperationException("La factura no existe");

            // Validar que no esté anulada
            if (factura.EstadoFactura == "Anulada")
                throw new InvalidOperationException("No se puede pagar una factura anulada");

            // Aquí va la lógica para registrar el pago
        }

        /// <summary>
        /// Calcula los intereses moratorios de una factura
        /// Implementación del principio SRP: Esta clase solo calcula intereses
        /// </summary>
        public decimal CalcularIntereses(Factura factura)
        {
            if (factura == null)
                throw new ArgumentNullException(nameof(factura));

            if (!factura.EstaVencida())
                return 0;

            // Calcular días de atraso
            var diasAtraso = (DateTime.Now - factura.FechaVencimiento).Days;
            
            // Aplicar 1% de interés mensual (0.033% diario)
            var tasaDiaria = 0.00033m;
            var interes = factura.TotalFactura * tasaDiaria * diasAtraso;

            return Math.Round(interes, 2);
        }
    }
}
