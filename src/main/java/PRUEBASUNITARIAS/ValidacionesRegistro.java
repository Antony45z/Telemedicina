/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package PRUEBASUNITARIAS;

/**
 *
 * @author Estudiante
 */
public class ValidacionesRegistro {
     // PRUEBA UNITARIA DE REGISTROSERVLET.JAVA
    /**
     * PRUEBA 6: EVALUA LA LOGICA DE ASIGNACION Y PROCESAMIENTO SEGUN EL ROL RECIBIDO
     */
    public String determinarFlujoPorRol(String rol) {
        if (rol == null || rol.trim().isEmpty()) {
            return "ROL_INVALIDO";
        }
        
        if ("PACIENTE".equalsIgnoreCase(rol)) {
            return "PROCESAR_DETALLE_PACIENTE";
        } else if ("MEDICO".equalsIgnoreCase(rol)) {
            return "PROCESAR_DETALLE_MEDICO";
        } else {
            return "ROL_DESCONOCIDO";
        }
    }

    /**
     * PRUEBA 7: EVALUA LA CONVERSIÓN DEL TEXTO A NUMERO ENTERO PARA LOS AÑOS DE EXPERIENCIA
     */
    public int evaluarAniosExperiencia(String experienciaStr) {
        if (experienciaStr == null || experienciaStr.trim().isEmpty()) {
            return 0; // Si no pone nada, por defecto es el número 0
        }
        
        try {
            int anios = Integer.parseInt(experienciaStr);
            if (anios >= 0) {
                return anios;
            } else {
                return 0; // No existen años de experiencia negativos
            }
        } catch (NumberFormatException e) {
            return 0; // El catch captura texto inválido y lo corrige a 0
        }
    }

    /**
     * PRUEBA 8: EVALUA SI EL ID GENERADO POR LA BASE DE DATOS PERMITE CONTINUAR CON EL FLUJO
     */
    public boolean puedeContinuarConDetalles(int idUsuario) {
        // En bases de datos, los IDs autoincrementables válidos inician desde 1
        return idUsuario > 0; // Éxito: Se puede registrar el detalle si es mayor a 0
    }
}
