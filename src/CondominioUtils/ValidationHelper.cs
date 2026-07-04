using System;

namespace CondominioUtils
{
    /// <summary>
    /// Clase auxiliar para validaciones comunes
    /// </summary>
    public static class ValidationHelper
    {
        /// <summary>
        /// Valida que un correo sea válido
        /// </summary>
        public static bool EsCorreoValido(string correo)
        {
            try
            {
                var address = new System.Net.Mail.MailAddress(correo);
                return address.Address == correo;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Valida que una cédula tenga formato válido
        /// </summary>
        public static bool EsCedulaValida(string cedula)
        {
            return !string.IsNullOrEmpty(cedula) && cedula.Length >= 9;
        }

        /// <summary>
        /// Valida que un monto sea positivo
        /// </summary>
        public static bool EsMontoValido(decimal monto)
        {
            return monto > 0;
        }
    }
}
