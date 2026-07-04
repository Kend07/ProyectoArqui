using System;
using System.Security.Cryptography;
using System.Text;

namespace CondominioUtils
{
    /// <summary>
    /// Clase auxiliar para operaciones criptográficas
    /// </summary>
    public static class CryptographyHelper
    {
        /// <summary>
        /// Encripta una contraseña usando SHA256
        /// </summary>
        public static string EncriptarContraseña(string password)
        {
            if (string.IsNullOrEmpty(password))
                throw new ArgumentException("La contraseña no puede estar vacía");

            using (var sha256 = SHA256.Create())
            {
                var hashedBytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                return Convert.ToBase64String(hashedBytes);
            }
        }

        /// <summary>
        /// Verifica si una contraseña coincide con su hash
        /// </summary>
        public static bool VerificarContraseña(string password, string hash)
        {
            var hashOfInput = EncriptarContraseña(password);
            return hashOfInput.Equals(hash);
        }
    }
}
