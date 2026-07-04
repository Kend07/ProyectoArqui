using System.Collections.Generic;
using CondominioEntities;

namespace CondominioInterfaces
{
    /// <summary>
    /// Interfaz para operaciones de acceso a datos de Factura
    /// </summary>
    public interface IFacturaDAO
    {
        /// <summary>
        /// Inserta una nueva factura
        /// </summary>
        int Insertar(Factura factura);

        /// <summary>
        /// Obtiene una factura por ID
        /// </summary>
        Factura ObtenerPorId(int id);

        /// <summary>
        /// Obtiene todas las facturas
        /// </summary>
        List<Factura> ObtenerTodas();

        /// <summary>
        /// Actualiza una factura
        /// </summary>
        void Actualizar(Factura factura);

        /// <summary>
        /// Elimina una factura (soft delete)
        /// </summary>
        void Eliminar(int id);

        /// <summary>
        /// Obtiene facturas pendientes de una propiedad
        /// </summary>
        List<Factura> ObtenerPendientes(int propiedadId);
    }
}
