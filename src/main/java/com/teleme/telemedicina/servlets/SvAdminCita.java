package com.teleme.telemedicina.servlets;

import dao.CitaDAO;
import dao.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SvAdminCita", urlPatterns = {"/AdministracionCita"})
public class SvAdminCita extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        try (Connection con = Conexion.getConexion()) {
            if (con == null) throw new SQLException("No se pudo conectar a la BD.");

            CitaDAO citaDAO = new CitaDAO();

            // 🔹 Eliminar cita
            if ("eliminar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idCita = Integer.parseInt(idStr);
                    boolean eliminado = citaDAO.eliminarCita(idCita);
                    if (eliminado) {
                        response.sendRedirect("AdministracionCita?mensaje=eliminado_ok");
                        return;
                    } else {
                        response.sendRedirect("AdministracionCita?mensaje=error");
                        return;
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect("AdministracionCita?mensaje=error");
                    return;
                }
            }

            // 🔹 Editar cita (mostrar formulario con datos)
            if ("editar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idCita = Integer.parseInt(idStr);
                    Map<String, Object> cita = citaDAO.obtenerCitaDetallada(idCita);
                    if (cita != null) {
                        request.setAttribute("cita", cita);
                        request.getRequestDispatcher("FormularioCita.jsp").forward(request, response);
                        return;
                    } else {
                        response.sendRedirect("AdministracionCita?mensaje=error");
                        return;
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect("AdministracionCita?mensaje=error");
                    return;
                }
            }

            // 🔹 Listar todas las citas (por defecto)
            List<Map<String, Object>> lista = citaDAO.listarCitasDetalladas();
            request.setAttribute("citas", lista);
            request.getRequestDispatcher("AdministracionCita.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al obtener citas: " + e.getMessage());
            request.setAttribute("tipoMensaje", "danger");
            request.getRequestDispatcher("AdministracionCita.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // De momento, redirige a GET (podrás usar POST en el formulario de creación/edición)
        response.sendRedirect("AdministracionCita");
    }
}
