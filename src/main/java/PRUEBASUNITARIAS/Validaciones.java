/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package PRUEBASUNITARIAS;

/**
 *
 * @author Estudiante
 */
public class Validaciones {
    
     // PRUEBAS UNITARIA DE PUBLICACIONSERVLET.JAVA
    /**
     * PRUEBA 1: METODO PARA VERIFICAR SI EL ID PARA ELIMINAR ES CORRECTO
     * Condicional: Si viene vacío, nulo, letras o menor/igual a cero, no se puede eliminar.
     */
    public boolean esIdValidoParaEliminar(String idTexto) {
        if (idTexto == null || idTexto.trim().isEmpty()) {
            return false;
        }

        try {
            int idNumero = Integer.parseInt(idTexto);
            
            if (idNumero > 0) {
                return true; // Camino feliz: ID válido para borrar
            } else {
                return false; // ID negativo o cero no existe
            }
            
        } catch (NumberFormatException e) {
            return false; // Condicional de error: Si meten letras en vez de números
        }
    }

    /**
     * PRUEBA 2: EVALUA LA ASIGNACIÓN POR DEFECTO CUANDO EL IDCATEGORIA ES INVALIDO
     * Si tiene letras, espacios o nulos, le asigna un 0 por defecto de forma segura.
     */
    public int corregirIdCategoria(String categoriaStr) {
        if (categoriaStr == null || categoriaStr.trim().isEmpty()) {
            return 0;
        }

        if (categoriaStr.matches("\\d+")) {
            return Integer.parseInt(categoriaStr);
        } else {
            return 0; //si tiene letras manda 0
        }
    }

    /**
     * PRUEBA 3: VALIDA QUE LOS CAMPOS OBLIGATORIOS DE LA PUBLICACIÓN NO ESTEN VACIOS
     * Verifica que tanto el título como el contenido no sean nulos ni puros espacios.
     */
    public boolean estanCamposCompletos(String titulo, String contenido) {
        if (titulo == null || titulo.trim().isEmpty()) {
            return false; 
        }

        if (contenido == null || contenido.trim().isEmpty()) {
            return false; 
        }

        return true; // Ambos campos están perfectos
    }

    /**
     * PRUEBA 4: EVALUA EL CONDICIONAL QUE DECIDE SI SE EDITA O SE REGISTRA UNA PUBLICACIÓN
     * Retorna una bandera en texto según el estado booleano de actualización.
     */
    public String determinarAccionGuardar(boolean actualizar) {
        if (actualizar) {
            return "EDITAR_REGISTRO"; // Camino cuando el registro ya existe (true)
        } else {
            return "CREAR_REGISTRO";  // Camino para un registro nuevo (false)
        }
    }

    /**
     * PRUEBA 5: EVALUA LOS DIFERENTES CAMINOS DEL SWITCH-CASE Y EL CONTROL DE NULOS
     * Valida el parámetro de acción que llega al flujo principal del Servlet.
     */
    public String validarAccionServlet(String accion) {
        if (accion == null) {
            return "listar";
        }
        
        switch (accion) {
            case "registrar":
                return "PROCESAR_REGISTRO";
            case "editar":
                return "PROCESAR_EDICION";
            default:
                return "REDIRECCION_A_LISTAR"; // Cualquier otra palabra desconocida redirige a la lista
        }
    }
}
