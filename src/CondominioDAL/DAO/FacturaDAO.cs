using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using CondominioEntities;
using CondominioInterfaces;

namespace CondominioDAL
{
    /// <summary>
    /// DAO para operaciones con Facturas en la base de datos
    /// </summary>
    public class FacturaDAO : IFacturaDAO
    {
        private readonly DatabaseConnection _databaseConnection;

        /// <summary>
        /// Constructor que recibe la conexión a la BD
        /// </summary>
        public FacturaDAO(DatabaseConnection databaseConnection)
        {
            _databaseConnection = databaseConnection ?? throw new ArgumentNullException(nameof(databaseConnection));
        }

        /// <summary>
        /// Inserta una nueva factura en la BD
        /// </summary>
        public int Insertar(Factura factura)
        {
            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = @"
                    INSERT INTO Facturas (NumeroFactura, PropiedadId, FechaVencimiento, 
                                         EstadoFactura, Subtotal, TotalInteres, TotalRecargo, TotalFactura)
                    VALUES (@NumeroFactura, @PropiedadId, @FechaVencimiento, 
                           @EstadoFactura, @Subtotal, @TotalInteres, @TotalRecargo, @TotalFactura);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@NumeroFactura", factura.NumeroFactura);
                    command.Parameters.AddWithValue("@PropiedadId", factura.PropiedadId);
                    command.Parameters.AddWithValue("@FechaVencimiento", factura.FechaVencimiento);
                    command.Parameters.AddWithValue("@EstadoFactura", factura.EstadoFactura);
                    command.Parameters.AddWithValue("@Subtotal", factura.Subtotal);
                    command.Parameters.AddWithValue("@TotalInteres", factura.TotalInteres);
                    command.Parameters.AddWithValue("@TotalRecargo", factura.TotalRecargo);
                    command.Parameters.AddWithValue("@TotalFactura", factura.TotalFactura);

                    return (int)(decimal)command.ExecuteScalar();
                }
            }
        }

        /// <summary>
        /// Obtiene una factura por ID
        /// </summary>
        public Factura ObtenerPorId(int id)
        {
            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = "SELECT * FROM Facturas WHERE FacturaId = @Id AND Activo = 1";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return MapeoFactura(reader);
                        }
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Obtiene todas las facturas
        /// </summary>
        public List<Factura> ObtenerTodas()
        {
            List<Factura> facturas = new List<Factura>();

            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = "SELECT * FROM Facturas WHERE Activo = 1 ORDER BY FechaCreacion DESC";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            facturas.Add(MapeoFactura(reader));
                        }
                    }
                }
            }

            return facturas;
        }

        /// <summary>
        /// Actualiza una factura
        /// </summary>
        public void Actualizar(Factura factura)
        {
            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = @"
                    UPDATE Facturas 
                    SET EstadoFactura = @EstadoFactura, 
                        TotalInteres = @TotalInteres,
                        TotalRecargo = @TotalRecargo,
                        TotalFactura = @TotalFactura,
                        Observacion = @Observacion,
                        FechaActualizacion = GETDATE()
                    WHERE FacturaId = @FacturaId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@FacturaId", factura.Id);
                    command.Parameters.AddWithValue("@EstadoFactura", factura.EstadoFactura);
                    command.Parameters.AddWithValue("@TotalInteres", factura.TotalInteres);
                    command.Parameters.AddWithValue("@TotalRecargo", factura.TotalRecargo);
                    command.Parameters.AddWithValue("@TotalFactura", factura.TotalFactura);
                    command.Parameters.AddWithValue("@Observacion", factura.Observacion ?? (object)DBNull.Value);

                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Elimina una factura (soft delete)
        /// </summary>
        public void Eliminar(int id)
        {
            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = "UPDATE Facturas SET Activo = 0, FechaActualizacion = GETDATE() WHERE FacturaId = @Id";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Id", id);
                    command.ExecuteNonQuery();
                }
            }
        }

        /// <summary>
        /// Obtiene facturas pendientes de una propiedad
        /// </summary>
        public List<Factura> ObtenerPendientes(int propiedadId)
        {
            List<Factura> facturas = new List<Factura>();

            using (SqlConnection connection = _databaseConnection.ObtenerConexion())
            {
                string query = @"
                    SELECT * FROM Facturas 
                    WHERE PropiedadId = @PropiedadId 
                    AND EstadoFactura = 'Pendiente' 
                    AND Activo = 1
                    ORDER BY FechaVencimiento ASC";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@PropiedadId", propiedadId);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            facturas.Add(MapeoFactura(reader));
                        }
                    }
                }
            }

            return facturas;
        }

        /// <summary>
        /// Mapea un DataReader a una entidad Factura
        /// </summary>
        private Factura MapeoFactura(SqlDataReader reader)
        {
            return new Factura
            {
                Id = (int)reader["FacturaId"],
                NumeroFactura = reader["NumeroFactura"].ToString(),
                PropiedadId = (int)reader["PropiedadId"],
                FechaEmision = (DateTime)reader["FechaEmision"],
                FechaVencimiento = (DateTime)reader["FechaVencimiento"],
                EstadoFactura = reader["EstadoFactura"].ToString(),
                Subtotal = (decimal)reader["Subtotal"],
                TotalInteres = reader["TotalInteres"] != DBNull.Value ? (decimal)reader["TotalInteres"] : 0,
                TotalRecargo = reader["TotalRecargo"] != DBNull.Value ? (decimal)reader["TotalRecargo"] : 0,
                TotalFactura = (decimal)reader["TotalFactura"],
                Observacion = reader["Observacion"] != DBNull.Value ? reader["Observacion"].ToString() : null,
                FechaCreacion = (DateTime)reader["FechaCreacion"]
            };
        }
    }
}
