namespace CondominioDTO
{
    /// <summary>
    /// DTO para transferencia de datos de Propiedad entre capas
    /// </summary>
    public class PropiedadDTO
    {
        /// <summary>
        /// ID de la propiedad
        /// </summary>
        public int PropiedadId { get; set; }

        /// <summary>
        /// Número de la propiedad
        /// </summary>
        public string NumeroCasa { get; set; }

        /// <summary>
        /// Tipo de propiedad
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
        /// Nombre del propietario
        /// </summary>
        public string NombrePropietario { get; set; }

        /// <summary>
        /// Bloque
        /// </summary>
        public string Bloque { get; set; }
    }
}
