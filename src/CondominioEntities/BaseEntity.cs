using System;

namespace CondominioEntities
{
    /// <summary>
    /// Clase base para todas las entidades del sistema
    /// </summary>
    public abstract class BaseEntity
    {
        /// <summary>
        /// Identificador único de la entidad
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Fecha de creación del registro
        /// </summary>
        public DateTime FechaCreacion { get; set; }

        /// <summary>
        /// Fecha de última actualización
        /// </summary>
        public DateTime? FechaActualizacion { get; set; }

        /// <summary>
        /// Indica si el registro está activo
        /// </summary>
        public bool Activo { get; set; } = true;

        /// <summary>
        /// Constructor de la clase base
        /// </summary>
        protected BaseEntity()
        {
            FechaCreacion = DateTime.Now;
            Activo = true;
        }
    }
}
