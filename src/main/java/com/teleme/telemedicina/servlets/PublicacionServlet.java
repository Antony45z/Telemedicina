package com.teleme.telemedicina.servlets;

// IMPORTAMOS LA CLASE VALIDACIONES DESDE SU PAQUETE
import PRUEBASUNITARIAS.Validaciones;

import dao.PublicacionDAO;
import dao.Conexion;
import modelo.Publicacion;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PublicacionServlet")
public class PublicacionServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PublicacionServlet.class.getName());
    private PublicacionDAO dao;
    
    // CREAMOS EL OBJETOS DE LA CLASE VALIDACIONES PARA USARLO EN TODO EL SERVLET
    private final Validaciones validador = new Validaciones();

    @Override
    public void init() throws ServletException {
        try {
            dao = new PublicacionDAO(Conexion.getConexion());
            LOGGER.info("PublicacionDAO inicializado correctamente.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al inicializar PublicacionDAO.", e);
            throw new ServletException("No se pudo conectar a la base de datos.", e);
        }
    }

    // GET → listar y eliminar
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accionParam = request.getParameter("accion");

        
        if (accionParam == null) {
            accionParam = "listar";
        }

        // PRUEBA 5: Validamos el flujo de la acción y controlamos los nulos
        String accion = validador.validarAccionServlet(accionParam);

        // Si la prueba detecta que debe redirigir por seguridad o error
        if (accion.equals("REDIRECCION_A_LISTAR") && !accionParam.equals("listar")) {
            response.sendRedirect("PublicacionServlet?accion=listar");
            return;
        }

        try {
            // El switch evalúa los casos limpios mapeados por la validación
            switch (accionParam) {

                case "listar":
                    listarPublicaciones(request, response);
                    break;

                case "eliminar":
                    eliminarPublicacion(request, response);
                    break;

                default:
                    // Si mandan basura en el parámetro, limpiamos redirigiendo a listar
                    response.sendRedirect("PublicacionServlet?accion=listar");
                    break;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en doGet (accion=" + accionParam + ")", e);
            response.sendError(500, "Error interno del servidor.");
        }
    }
    // POST → registrar y editar
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String accionParam = request.getParameter("accion");
        
        // PRUEBA 5: Validamos los caminos del switch-case para el método POST
        String accion = validador.validarAccionServlet(accionParam);

        try {
            switch (accion) {

                case "PROCESAR_REGISTRO":
                    guardarPublicacion(request, response, false);
                    break;

                case "PROCESAR_EDICION":
                    guardarPublicacion(request, response, true);
                    break;

                default:
                    response.sendRedirect("PublicacionServlet?accion=listar");
                    break;
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error en doPost (accion=" + accionParam + ")", e);
            response.sendError(500, "Error interno del servidor.");
        }
    }

    // LISTAR
    private void listarPublicaciones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Publicacion> lista = dao.obtenerTodas();
            request.setAttribute("publicaciones", lista);
            request.getRequestDispatcher("AdministracionPublicaciones.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error listando publicaciones.", e);
            response.sendError(500, "No se pudieron cargar las publicaciones.");
        }
    }

    // ELIMINAR
    private void eliminarPublicacion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idTexto = request.getParameter("id");

        // PRUEBA 1: Invocamos la validación del ID antes de intentar borrar
        if (validador.esIdValidoParaEliminar(idTexto)) {
            int id = Integer.parseInt(idTexto);
            boolean ok = dao.eliminarPublicacion(id);

            if (!ok) {
                LOGGER.warning("No se pudo eliminar la publicación ID=" + id);
            }
        } else {
            LOGGER.log(Level.WARNING, "ID inválido o malicioso rechazado para eliminación: " + idTexto);
        }

        response.sendRedirect("PublicacionServlet?accion=listar");
    }

    // REGISTRAR / EDITAR
    private void guardarPublicacion(HttpServletRequest request, HttpServletResponse response, boolean actualizar)
            throws IOException {

        // PRUEBA 4: Evaluamos si el flujo actual corresponde a registrar o editar
        String tipoOperacion = validador.determinarAccionGuardar(actualizar);
        LOGGER.info("Ejecutando operación de guardado tipo: " + tipoOperacion);

        Publicacion p = new Publicacion();

        if (actualizar) {
            String idPublicacionStr = request.getParameter("idPublicacion");
            // Usamos también la PRUEBA 1 para asegurar que el ID de edición sea válido
            if (validador.esIdValidoParaEliminar(idPublicacionStr)) {
                p.setIdPublicacion(Integer.parseInt(idPublicacionStr));
            } else {
                LOGGER.log(Level.WARNING, "ID inválido para actualizar: " + idPublicacionStr);
                response.sendRedirect("PublicacionServlet?accion=listar");
                return;
            }
        }

        String titulo = request.getParameter("titulo");
        String contenido = request.getParameter("contenido");

        // PRUEBA 3: Validamos que los campos obligatorios contengan información real
        if (!validador.estanCamposCompletos(titulo, contenido)) {
            LOGGER.log(Level.WARNING, "Intento fallido de guardar campos vacíos.");
            response.sendRedirect("PublicacionServlet?accion=listar");
            return;
        }

        try {
            p.setIdMedico(Integer.parseInt(request.getParameter("idMedico")));
            p.setTitulo(titulo);
            p.setContenido(contenido);

            // PRUEBA 2: Corregimos de forma automática y segura el ID de la categoría
            String categoriaStr = request.getParameter("idCategoria");
            p.setIdCategoria(validador.corregirIdCategoria(categoriaStr));

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error procesando campos numéricos del formulario.", e);
            response.sendRedirect("PublicacionServlet?accion=listar");
            return;
        }

        boolean ok;

        if (actualizar) {
            ok = dao.actualizarPublicacion(p);
            if (!ok) LOGGER.warning("No se pudo actualizar la publicación ID=" + p.getIdPublicacion());
        } else {
            ok = dao.insertarPublicacion(p);
            if (!ok) LOGGER.warning("Error registrando nueva publicación.");
        }

        response.sendRedirect("PublicacionServlet?accion=listar");
    }
}