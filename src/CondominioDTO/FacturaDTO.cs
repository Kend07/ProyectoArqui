namespace CondominioDTO
{
    /// <summary>
    /// DTO para transferencia de datos de Factura entre capas
    /// </summary>
    public class FacturaDTO
    {
        /// <summary>
        /// ID de la factura
        /// </summary>
        public int FacturaId { get; set; }

        /// <summary>
        /// Número de factura
        /// </summary>
        public string NumeroFactura { get; set; }

        /// <summary>
        /// ID de la propiedad
        /// </summary>
        public int PropiedadId { get; set; }

        /// <summary>
        /// Descripción de la propiedad
        /// </summary>
        public string DescripcionPropiedad { get; set; }

        /// <summary>
        /// Estado de la factura
        /// </summary>
        public string Estado { get; set; }

        /// <summary>
        /// Total de la factura
        /// </summary>
        public decimal Total { get; set; }

        /// <summary>
        /// Saldo pendiente
        /// </summary>
        public decimal SaldoPendiente { get; set; }
    }
}
