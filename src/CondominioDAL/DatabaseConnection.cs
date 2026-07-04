using System.Data;
using System.Data.SqlClient;

namespace CondominioDAL
{
    /// <summary>
    /// Clase para manejar la conexión con la base de datos
    /// </summary>
    public class DatabaseConnection
    {
        private readonly string _connectionString;

        /// <summary>
        /// Constructor que recibe la cadena de conexión
        /// </summary>
        public DatabaseConnection(string connectionString)
        {
            _connectionString = connectionString;
        }

        /// <summary>
        /// Obtiene una conexión abierta a la base de datos
        /// </summary>
        public SqlConnection ObtenerConexion()
        {
            var connection = new SqlConnection(_connectionString);
            connection.Open();
            return connection;
        }

        /// <summary>
        /// Prueba la conexión a la base de datos
        /// </summary>
        public bool PruebaConexion()
        {
            try
            {
                using (var connection = ObtenerConexion())
                {
                    return connection.State == ConnectionState.Open;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
