using System;
using System.Collections.Generic;

namespace CondominioEntities
{
    /// <summary>
    /// Entidad que representa una Factura en el sistema
    /// </summary>
    public class Factura : BaseEntity
    {
        /// <summary>
        /// Número único de la factura
        /// </summary>
        public string NumeroFactura { get; set; }

        /// <summary>
        /// ID de la propiedad asociada
        /// </summary>
        public int PropiedadId { get; set; }

        /// <summary>
        /// Fecha de emisión de la factura
        /// </summary>
        public DateTime FechaEmision { get; set; }

        /// <summary>
        /// Fecha de vencimiento de pago
        /// </summary>
        public DateTime FechaVencimiento { get; set; }

        /// <summary>
        /// Estado de la factura (Pendiente, Pagada, Anulada)
        /// </summary>
        public string EstadoFactura { get; set; } = "Pendiente";

        /// <summary>
        /// Subtotal sin intereses ni recargos
        /// </summary>
        public decimal Subtotal { get; set; }

        /// <summary>
        /// Total de intereses moratorios
        /// </summary>
        public decimal TotalInteres { get; set; }

        /// <summary>
        /// Total de recargos aplicados
        /// </summary>
        public decimal TotalRecargo { get; set; }

        /// <summary>
        /// Monto total de la factura
        /// </summary>
        public decimal TotalFactura { get; set; }

        /// <summary>
        /// Observaciones adicionales
        /// </summary>
        public string Observacion { get; set; }

        /// <summary>
        /// Detalles de la factura (múltiples cargos)
        /// </summary>
        public List<DetalleFactura> Detalles { get; set; } = new List<DetalleFactura>();

        /// <summary>
        /// Obtiene el saldo pendiente de la factura
        /// </summary>
        public decimal ObtenerSaldoPendiente(decimal pagos)
        {
            return TotalFactura - pagos;
        }

        /// <summary>
        /// Marca la factura como pagada
        /// </summary>
        public void MarcarComoPagada()
        {
            EstadoFactura = "Pagada";
            FechaActualizacion = DateTime.Now;
        }

        /// <summary>
        /// Valida si la factura está vencida
        /// </summary>
        public bool EstaVencida()
        {
            return DateTime.Now > FechaVencimiento && EstadoFactura != "Pagada";
        }
    }

    /// <summary>
    /// Clase que representa un detalle de factura
    /// </summary>
    public class DetalleFactura
    {
        /// <summary>
        /// ID del detalle
        /// </summary>
        public int DetalleId { get; set; }

        /// <summary>
        /// ID de la factura asociada
        /// </summary>
        public int FacturaId { get; set; }

        /// <summary>
        /// Descripción del cargo
        /// </summary>
        public string Descripcion { get; set; }

        /// <summary>
        /// Cantidad del cargo
        /// </summary>
        public int Cantidad { get; set; }

        /// <summary>
        /// Valor unitario del cargo
        /// </summary>
        public decimal ValorUnitario { get; set; }

        /// <summary>
        /// Subtotal del detalle
        /// </summary>
        public decimal Subtotal { get; set; }

        /// <summary>
        /// Calcula el subtotal automáticamente
        /// </summary>
        public void CalcularSubtotal()
        {
            Subtotal = Cantidad * ValorUnitario;
        }
    }
}
