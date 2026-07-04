using System;

namespace CondominioEntities
{
    /// <summary>
    /// Entidad que representa una Propiedad en el condominio
    /// </summary>
    public class Propiedad : BaseEntity
    {
        /// <summary>
        /// Número único de la propiedad
        /// </summary>
        public string NumeroCasa { get; set; }

        /// <summary>
        /// Tipo de propiedad (Apartamento, Casa, Local)
        /// </summary>
        public string TipoCasa { get; set; }

        /// <summary>
        /// Área en metros cuadrados
        /// </summary>
        public decimal AreaMetrosCuadrados { get; set; }

        /// <summary>
        /// Número de habitaciones
        /// </summary>
        public int NumeroHabitaciones { get; set; }

        /// <summary>
        /// ID del propietario
        /// </summary>
        public int PropietarioId { get; set; }

        /// <summary>
        /// Número del piso
        /// </summary>
        public int? Piso { get; set; }

        /// <summary>
        /// Bloque o sección
        /// </summary>
        public string Bloque { get; set; }

        /// <summary>
        /// Fecha de compra
        /// </summary>
        public DateTime? FechaCompra { get; set; }

        /// <summary>
        /// Valida que el área sea válida (positiva)
        /// </summary>
        public bool ValidarArea()
        {
            return AreaMetrosCuadrados > 0;
        }

        /// <summary>
        /// Obtiene una descripción legible de la propiedad
        /// </summary>
        public string ObtenerDescripcion()
        {
            return $"{TipoCasa} {NumeroCasa} - Bloque {Bloque}, Piso {(Piso.HasValue ? Piso.ToString() : "N/A")}";
        }
    }
}
