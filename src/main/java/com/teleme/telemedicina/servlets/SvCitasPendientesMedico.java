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

@WebServlet(name = "SvCitasPendientesMedico", urlPatterns = {"/SvCitasPendientesMedico"})
public class SvCitasPendientesMedico extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        if (sesion == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String rol = (String) sesion.getAttribute("rol");

        if (rol == null || !rol.equalsIgnoreCase("MEDICO")) {
            response.sendRedirect("AccesoDenegado.jsp");
            return;
        }

        Integer idMedico = (Integer) sesion.getAttribute("idMedico");

        if (idMedico == null || idMedico <= 0) {
            response.sendRedirect("AccesoDenegado.jsp");
            return;
        }

        try (Connection con = Conexion.getConexion()) {
            CitaDAO dao = new CitaDAO();
            List<Map<String, Object>> citasPendientes = dao.listarPendientesPorMedico(idMedico);

            // 🧠 Debug opcional en consola
            System.out.println("✅ ID Médico en sesión: " + idMedico);
            System.out.println("📋 Total de citas pendientes encontradas: " + citasPendientes.size());

            // Enviar la lista al JSP
            request.setAttribute("citasPendientes", citasPendientes);
            request.getRequestDispatcher("VerCitaMedicoPendiente.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensajeError", "Error al cargar las citas: " + e.getMessage());
            request.getRequestDispatcher("Error.jsp").forward(request, response);
        }
    }
}
