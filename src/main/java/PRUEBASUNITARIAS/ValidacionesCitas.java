/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package PRUEBASUNITARIAS;

/**
 *
 * @author Estudiante
 */
public class ValidacionesCitas {
     // PRUEBA UNITARIA DE SVACTUALIZARESTADOCITA.JAVA
    /**
     * PRUEBA 9: VALIDA QUE EL ID DE LA CITA SEA UN NÚMERO VÁLIDO Y CORRECTO
     * Verifica que el texto no sea nulo, no esté vacío y sea un número mayor a cero.
     */
    public boolean esIdCitaValido(String idCitaStr) {
        if (idCitaStr == null || idCitaStr.trim().isEmpty()) {
            return false;
        }
        
        try {
            int idCita = Integer.parseInt(idCitaStr);
            // El ID de la cita en la tabla debe ser un número positivo
            return idCita > 0;
        } catch (NumberFormatException e) {
            // Si mandan letras, el catch lo captura de forma segura
            return false;
        }
    }

    /**
     * PRUEBA 10: DETERMINA LA URL DE DESTINO BASÁNDOSE EN SI LA BASE DE DATOS RESPONDIÓ CON ÉXITO
     * Centraliza las cadenas de redirección con sus respectivos parámetros de mensaje.
     */
    public String obtenerUrlRedireccion(boolean fueExitoso) {
        if (fueExitoso) {
            // Camino feliz
            return "AdministracionCita?mensaje=actualizado_ok";
        } else {
            // Camino en caso de error o fallo en la base de datos
            return "AdministracionCita?mensaje=error";
        }
    }
}
