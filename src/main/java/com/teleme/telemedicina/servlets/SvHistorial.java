package com.teleme.telemedicina.servlets;

import dao.CitaDAO;
import dao.DiagnosticoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "SvHistorial", urlPatterns = {"/SvHistorial"})
public class SvHistorial extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession(false);

        // ✅ Validar sesión
        if (sesion == null || sesion.getAttribute("rol") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String rol = (String) sesion.getAttribute("rol");

        Integer idPaciente =
            (Integer) sesion.getAttribute("idPaciente");

        Integer idMedico =
            (Integer) sesion.getAttribute("idMedico");

        String tipo =
            request.getParameter("tipo");

        // ✅ Instanciar DAOs
        CitaDAO citaDAO = new CitaDAO();
        DiagnosticoDAO diagDAO = new DiagnosticoDAO();

        try {

            // =========================
            // PACIENTE
            // =========================
            if ("PACIENTE".equalsIgnoreCase(rol)) {

                if ("citas".equalsIgnoreCase(tipo)) {

                    request.setAttribute(
                        "listaCitas",
                        citaDAO.listarCitasPorPaciente(idPaciente)
                    );

                    request.getRequestDispatcher(
                        "VerCitaPaciente.jsp"
                    ).forward(request, response);

                    return;
                }

                if ("diagnosticos".equalsIgnoreCase(tipo)) {

                    request.setAttribute(
                        "listaDiagnosticos",
                        diagDAO.listarDiagnosticosPorPaciente(idPaciente)
                    );

                    request.getRequestDispatcher(
                        "VerDiagnosticoPaciente.jsp"
                    ).forward(request, response);

                    return;
                }

                response.sendRedirect("IndexPaciente.jsp");
                return;
            }

            // =========================
            // ROL NO AUTORIZADO
            // =========================
            response.sendRedirect("AccesoDenegado.jsp");

        } catch (Exception e) {

            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}