package com.teleme.telemedicina.servlets;

import dao.MedicoDAO;
import dao.Conexion;
import modelo.Medico;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SvMedico")
public class SvMedico extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        try (Connection con = Conexion.getConexion()) {
            MedicoDAO dao = new MedicoDAO(con);

            if ("listarParaCita".equals(accion)) {
                // Este método debes crearlo en MedicoDAO
                List<Medico> lista = dao.listarMedicosParaCita();
                request.setAttribute("medicos", lista);
                request.getRequestDispatcher("agendarCita.jsp").forward(request, response);
            } else if ("listarAdmin".equals(accion)) {
                // Este ya lo tienes
                List<Medico> lista = dao.listarMedicos();
                request.setAttribute("medicos", lista);
                request.getRequestDispatcher("listarMedicos.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud de médicos");
        }
    }
}
