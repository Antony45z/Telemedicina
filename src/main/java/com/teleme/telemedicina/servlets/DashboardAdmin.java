package com.teleme.telemedicina.servlets;

import dao.CitaDAO;    
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

@WebServlet("/DashboardAdmin")
public class DashboardAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        CitaDAO dao = new CitaDAO();
        Map<Integer, Integer> citas = dao.obtenerCitasPorMes2025();

        req.setAttribute("citasMes", citas);
        req.getRequestDispatcher("AdministracionDashboard.jsp").forward(req, resp);
    }
}
