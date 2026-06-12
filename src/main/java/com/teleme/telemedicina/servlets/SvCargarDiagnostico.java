
package com.teleme.telemedicina.servlets;

import dao.CitaDAO;
import dao.DiagnosticoDAO;
import modelo.Diagnostico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
/**
 *
 * @author ERICK
 */
    @WebServlet(name = "SvCargarDiagnostico", urlPatterns = {"/SvCargarDiagnostico"})
public class SvCargarDiagnostico extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idCita = Integer.parseInt(request.getParameter("idCita"));
        DiagnosticoDAO diagDAO = new DiagnosticoDAO();
        Diagnostico diag = null;

        try {
            List<Diagnostico> lista = diagDAO.listarDiagnosticosPorMedico(0); // opcional: cambiar por consulta específica
            for(Diagnostico d : lista){
                if(d.getIdCita() == idCita){
                    diag = d;
                    break;
                }
            }

            request.setAttribute("diagnosticoExistente", diag);
            request.setAttribute("ticket", request.getParameter("ticket"));
            request.setAttribute("idCita", idCita);

            request.getRequestDispatcher("VideoConsultaMedico.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Error.jsp");
        }
    }
}


