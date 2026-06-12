package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.PublicacionDAO;
import modelo.Publicacion;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SvPublicacion", urlPatterns = {"/SvPublicacion"})
public class SvPublicacion extends HttpServlet {

    // ✅ Registrar una nueva publicación
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        if (sesion.getAttribute("idMedico") == null) {
            response.sendRedirect("AccesoDenegado.jsp");
            return;
        }

        int idMedico = (int) sesion.getAttribute("idMedico");
        String idCategoriaStr = request.getParameter("id_categoria");
        String titulo = request.getParameter("titulo");
        String contenido = request.getParameter("contenido");

        // Validación de campos
        if (idCategoriaStr == null || idCategoriaStr.isEmpty() ||
            titulo == null || titulo.trim().isEmpty() ||
            contenido == null || contenido.trim().isEmpty()) {

            request.setAttribute("error", "Debe completar todos los campos.");
            cargarPublicacionesYRedirigir(idMedico, request, response);
            return;
        }

        int idCategoria = Integer.parseInt(idCategoriaStr);

        try (Connection con = Conexion.getConexion()) {
            PublicacionDAO dao = new PublicacionDAO(con);

            Publicacion publicacion = new Publicacion();
            publicacion.setIdMedico(idMedico);
            publicacion.setIdCategoria(idCategoria);
            publicacion.setTitulo(titulo.trim());
            publicacion.setContenido(contenido.trim());

            boolean guardado = dao.insertarPublicacion(publicacion);

            if (guardado) {
                request.setAttribute("mensaje", "✅ ¡Publicación creada correctamente!");
            } else {
                request.setAttribute("error", "❌ Error al registrar la publicación.");
            }

            // 🔹 Mostrar nuevamente la página con la lista actualizada
            cargarPublicacionesYRedirigir(idMedico, request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error en el servidor: " + e.getMessage());
            cargarPublicacionesYRedirigir(idMedico, request, response);
        }
    }

    // ✅ Mostrar publicaciones al entrar a la página (GET)
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

        if (sesion.getAttribute("idMedico") == null) {
            response.sendRedirect("AccesoDenegado.jsp");
            return;
        }

        int idMedico = (int) sesion.getAttribute("idMedico");
        cargarPublicacionesYRedirigir(idMedico, request, response);
    }

    // 🔹 Método auxiliar para evitar duplicar código
    private void cargarPublicacionesYRedirigir(int idMedico, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection con = Conexion.getConexion()) {
            PublicacionDAO dao = new PublicacionDAO(con);
            List<Publicacion> publicaciones = dao.listarPorMedico(idMedico);

            request.setAttribute("publicaciones", publicaciones);
            request.getRequestDispatcher("HomeMedico.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al cargar publicaciones: " + e.getMessage());
            request.getRequestDispatcher("HomeMedico.jsp").forward(request, response);
        }
    }
}
