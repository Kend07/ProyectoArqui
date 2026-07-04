using System.Collections.Generic;

namespace CondominioInterfaces
{
    /// <summary>
    /// Interfaz genérica para operaciones CRUD
    /// </summary>
    public interface IRepositorio<T> where T : class
    {
        /// <summary>
        /// Inserta un nuevo registro
        /// </summary>
        int Crear(T entidad);

        /// <summary>
        /// Obtiene un registro por ID
        /// </summary>
        T Obtener(int id);

        /// <summary>
        /// Obtiene todos los registros
        /// </summary>
        List<T> ObtenerTodos();

        /// <summary>
        /// Actualiza un registro
        /// </summary>
        void Actualizar(T entidad);

        /// <summary>
        /// Elimina un registro
        /// </summary>
        void Eliminar(int id);
    }
}
