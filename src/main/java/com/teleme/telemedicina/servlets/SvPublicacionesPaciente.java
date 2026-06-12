package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.PublicacionDAO;
import dao.MedicoDAO;
import modelo.Publicacion;
import modelo.Medico;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/SvPublicacionesPaciente")
public class SvPublicacionesPaciente extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Verificar sesión de paciente
        HttpSession sesion = request.getSession(false);

        //No existe sesión
        if (sesion == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        //Existe sesión pero no es paciente
        String rol = (String) sesion.getAttribute("rol");
        Integer idPaciente = (Integer) sesion.getAttribute("idPaciente");

        if (rol == null || !"PACIENTE".equalsIgnoreCase(rol) || idPaciente == null) {
            response.sendRedirect("AccesoDenegado.jsp");
            return;
        }

        try (Connection con = Conexion.getConexion()) {

            //Obtener publicaciones
            PublicacionDAO pubDao = new PublicacionDAO(con);
            List<Publicacion> publicaciones = pubDao.obtenerTodas();
            request.setAttribute("publicaciones", publicaciones);

            //Obtener top 3 doctores con más citas completadas
            MedicoDAO medicoDao = new MedicoDAO(con);
            List<Medico> topDoctores = medicoDao.obtenerTopDoctores();
            request.setAttribute("topDoctores", topDoctores);

            //Redirigir al JSP
            request.getRequestDispatcher("IndexPaciente.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "No se pudieron cargar los datos: " + e.getMessage());
            request.getRequestDispatcher("IndexPaciente.jsp").forward(request, response);
        }
    }
}
