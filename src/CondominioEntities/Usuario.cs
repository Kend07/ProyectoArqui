using System;

namespace CondominioEntities
{
    /// <summary>
    /// Entidad que representa un Usuario del sistema
    /// </summary>
    public class Usuario : BaseEntity
    {
        /// <summary>
        /// Nombre de usuario único
        /// </summary>
        public string NombreUsuario { get; set; }

        /// <summary>
        /// Correo electrónico único
        /// </summary>
        public string Correo { get; set; }

        /// <summary>
        /// Hash de la contraseña (encriptada)
        /// </summary>
        public string PasswordHash { get; set; }

        /// <summary>
        /// ID del rol asignado
        /// </summary>
        public int RolId { get; set; }

        /// <summary>
        /// Nombre del usuario
        /// </summary>
        public string PrimerNombre { get; set; }

        /// <summary>
        /// Apellido paterno
        /// </summary>
        public string ApellidoPaterno { get; set; }

        /// <summary>
        /// Apellido materno
        /// </summary>
        public string ApellidoMaterno { get; set; }

        /// <summary>
        /// Último acceso al sistema
        /// </summary>
        public DateTime? UltimoAcceso { get; set; }

        /// <summary>
        /// Obtiene el nombre completo del usuario
        /// </summary>
        public string ObtenerNombreCompleto()
        {
            return $"{PrimerNombre} {ApellidoPaterno} {ApellidoMaterno}".Trim();
        }

        /// <summary>
        /// Valida que el usuario tenga datos requeridos
        /// </summary>
        public bool ValidarDatos()
        {
            return !string.IsNullOrEmpty(NombreUsuario) &&
                   !string.IsNullOrEmpty(Correo) &&
                   !string.IsNullOrEmpty(PasswordHash) &&
                   !string.IsNullOrEmpty(PrimerNombre) &&
                   !string.IsNullOrEmpty(ApellidoPaterno);
        }
    }
}
