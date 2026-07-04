namespace CondominioUtils
{
    /// <summary>
    /// Extensiones para la clase string
    /// </summary>
    public static class StringExtensions
    {
        /// <summary>
        /// Trunca un string a una longitud máxima
        /// </summary>
        public static string Truncar(this string texto, int longitudMaxima)
        {
            if (string.IsNullOrEmpty(texto))
                return texto;

            return texto.Length <= longitudMaxima ? texto : texto.Substring(0, longitudMaxima) + "...";
        }

        /// <summary>
        /// Capitaliza la primera letra
        /// </summary>
        public static string CapitalizarPrimera(this string texto)
        {
            if (string.IsNullOrEmpty(texto))
                return texto;

            return char.ToUpper(texto[0]) + texto.Substring(1).ToLower();
        }
    }
}
