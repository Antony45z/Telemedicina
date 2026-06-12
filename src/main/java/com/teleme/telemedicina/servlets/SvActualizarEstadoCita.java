package com.teleme.telemedicina.servlets;

// IMPORTAMOS LA NUEVA CLASE DE VALIDACIÓN DE CITAS
import PRUEBASUNITARIAS.ValidacionesCitas;

import dao.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "SvActualizarEstadoCita", urlPatterns = {"/SvActualizarEstadoCita"})
public class SvActualizarEstadoCita extends HttpServlet {

    // INSTANCIAMOS EL OBJETO DE NUESTRAS PRUEBAS DE VALIDACIÓN
    private final ValidacionesCitas validador = new ValidacionesCitas();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Recibimos primero el parámetro como texto original
        String idCitaStr = request.getParameter("idCita");
        String nuevoEstado = request.getParameter("nuevoEstado");

        // PRUEBA 9: Validamos que el ID de la cita sea seguro y correcto antes de procesarlo
        if (!validador.esIdCitaValido(idCitaStr)) {
            // Si el ID es inválido, determinamos la URL de redirección como fallo (false)
            String urlError = validador.obtenerUrlRedireccion(false);
            response.sendRedirect(urlError);
            return;
        }

        // Una vez que pasó la validación de la Prueba 9, ya podemos parsear de forma segura
        int idCita = Integer.parseInt(idCitaStr);
        String sql = "UPDATE citas SET estado = ? WHERE id_cita = ?";

        try (Connection con = Conexion.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idCita);
            ps.executeUpdate();

            // PRUEBA 10: Camino feliz (true) -> Genera la URL de éxito dinámicamente
            String urlExito = validador.obtenerUrlRedireccion(true);
            response.sendRedirect(urlExito);

        } catch (SQLException e) {
            e.printStackTrace();
            
            // PRUEBA 10: Camino de error (false) -> Genera la URL de fallo dinámicamente
            String urlError = validador.obtenerUrlRedireccion(false);
            response.sendRedirect(urlError);
        }
    }
}