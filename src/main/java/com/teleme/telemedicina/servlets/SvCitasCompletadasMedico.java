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

@WebServlet(name = "SvCitasCompletadasMedico", urlPatterns = {"/SvCitasCompletadasMedico"})
public class SvCitasCompletadasMedico extends HttpServlet {

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
            // 🔹 Usa el método nuevo que incluye diagnóstico
            List<Map<String, Object>> citasCompletadas = dao.listarCompletadasConDiagnostico(idMedico);

            request.setAttribute("citasCompletadas", citasCompletadas);
            request.getRequestDispatcher("VerCitaMedicoCompletada.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Error.jsp");
        }
    }
}
