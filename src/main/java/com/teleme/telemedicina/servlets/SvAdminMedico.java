package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.MedicoDAO;
import dao.UsuarioDAO;
import modelo.Medico;
import modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "SvAdminMedico", urlPatterns = {"/AdministracionMedico"})
public class SvAdminMedico extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        try (Connection con = Conexion.getConexion()) {
            if (con == null) throw new SQLException("No se pudo conectar a la BD.");

            MedicoDAO medicoDAO = new MedicoDAO(con);
            UsuarioDAO usuarioDAO = new UsuarioDAO(con);

            // EDITAR -> cargar datos y forward al formulario
            if ("editar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idMedico = Integer.parseInt(idStr);
                    Medico medico = medicoDAO.obtenerPorId(idMedico);
                    if (medico != null) {
                        // obtener datos adicionales de usuario (fecha, tipo doc, num doc, direccion...)
                        Usuario usuario = usuarioDAO.obtenerPorId(medico.getIdUsuario());
                        request.setAttribute("medico", medico);
                        request.setAttribute("usuario", usuario);
                        request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("mensaje", "No se encontró el médico con ese ID");
                        request.setAttribute("tipoMensaje", "danger");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "ID de médico inválido");
                    request.setAttribute("tipoMensaje", "danger");
                }
                // listar y mostrar mensaje si fallo
                List<Medico> listaMedicos = medicoDAO.listarMedicos();
                request.setAttribute("medicos", listaMedicos);
                request.getRequestDispatcher("AdministracionMedico.jsp").forward(request, response);
                return;
            }

            // ELIMINAR
            if ("eliminar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idMedico = Integer.parseInt(idStr);
                    boolean eliminado = medicoDAO.eliminarMedico(idMedico);
                    if (eliminado) {
                        response.sendRedirect("AdministracionMedico?mensaje=eliminado_ok");
                        return;
                    } else {
                        request.setAttribute("mensaje", "No se pudo eliminar el médico");
                        request.setAttribute("tipoMensaje", "danger");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "ID inválido");
                    request.setAttribute("tipoMensaje", "danger");
                }
            }

            // AGREGAR -> redirigir al formulario en modo nuevo
            if ("agregar".equalsIgnoreCase(accion)) {
                request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
                return;
            }
            
            // LISTAR por defecto
            List<Medico> lista = medicoDAO.listarMedicos();
            request.setAttribute("medicos", lista);
            request.getRequestDispatcher("AdministracionMedico.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al obtener médicos: " + e.getMessage());
            request.setAttribute("tipoMensaje", "danger");
            request.getRequestDispatcher("AdministracionMedico.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String accion = request.getParameter("accion");

    try (Connection con = Conexion.getConexion()) {

        if (con == null) {
            throw new SQLException("No se pudo conectar.");
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO(con);

        // CAMBIAR ESTADO DESDE EL MODAL
        if ("estado".equalsIgnoreCase(accion)) {

            int idUsuario = Integer.parseInt(
                    request.getParameter("idUsuario")
            );

            String estado = request.getParameter("estado");

            String info = request.getParameter("info");

            if(info != null && info.trim().isEmpty()){
                info = null;
            }

            usuarioDAO.actualizarEstadoCuenta(
                    idUsuario,
                    estado,
                    info
            );
            if("Activo".equalsIgnoreCase(estado)){

                usuarioDAO.reiniciarIntentos(idUsuario);
            }
            response.sendRedirect(
                    "AdministracionMedico?mensaje=estado_ok"
            );

            return;
        }

        // SI NO HAY ACCIÓN
        response.sendRedirect("AdministracionMedico");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "AdministracionMedico?mensaje=error"
            );
        }
    }
}
