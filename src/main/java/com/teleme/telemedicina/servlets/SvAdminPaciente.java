package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.PacienteDAO;
import dao.UsuarioDAO;
import modelo.Paciente;
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

@WebServlet(name = "SvAdminPaciente", urlPatterns = {"/AdministracionPaciente"})
public class SvAdminPaciente extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");
        String idStr = request.getParameter("id");

        try (Connection con = Conexion.getConexion()) {
            if (con == null) throw new SQLException("No se pudo conectar a la base de datos.");

            PacienteDAO pacienteDAO = new PacienteDAO(con);
            UsuarioDAO usuarioDAO = new UsuarioDAO(con);

            // ✏️ EDITAR — cargar datos y redirigir al formulario
            if ("editar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idPaciente = Integer.parseInt(idStr);
                    Paciente paciente = pacienteDAO.obtenerPorId(idPaciente);

                    if (paciente != null) {
                        // Cargar también los datos de su usuario asociado
                        Usuario usuario = usuarioDAO.obtenerPorId(paciente.getIdUsuario());

                        request.setAttribute("paciente", paciente);
                        request.setAttribute("usuario", usuario);
                        request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("mensaje", "No se encontró el paciente con ese ID.");
                        request.setAttribute("tipoMensaje", "danger");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "ID de paciente inválido.");
                    request.setAttribute("tipoMensaje", "danger");
                }

                // listar y mostrar mensaje si algo falla
                List<Paciente> listaPacientes = pacienteDAO.listarPacientes();
                request.setAttribute("pacientes", listaPacientes);
                request.getRequestDispatcher("AdministracionPaciente.jsp").forward(request, response);
                return;
            }

            // 🗑 ELIMINAR
            if ("eliminar".equalsIgnoreCase(accion) && idStr != null) {
                try {
                    int idPaciente = Integer.parseInt(idStr);
                    boolean eliminado = pacienteDAO.eliminarPaciente(idPaciente);
                    if (eliminado) {
                        response.sendRedirect("AdministracionPaciente?mensaje=eliminado_ok");
                        return;
                    } else {
                        request.setAttribute("mensaje", "No se pudo eliminar el paciente.");
                        request.setAttribute("tipoMensaje", "danger");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("mensaje", "ID inválido.");
                    request.setAttribute("tipoMensaje", "danger");
                }
            }

            // ➕ AGREGAR — abrir formulario vacío
            if ("agregar".equalsIgnoreCase(accion)) {
                request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
                return;
            }

            // 📋 LISTAR por defecto
            List<Paciente> lista = pacienteDAO.listarPacientes();
            request.setAttribute("pacientes", lista);
            request.getRequestDispatcher("AdministracionPaciente.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "Error al obtener pacientes: " + e.getMessage());
            request.setAttribute("tipoMensaje", "danger");
            request.getRequestDispatcher("AdministracionPaciente.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

    try (Connection con = Conexion.getConexion()) {

        UsuarioDAO usuarioDAO = new UsuarioDAO(con);

            if ("estado".equalsIgnoreCase(accion)) {

                int idUsuario = Integer.parseInt(
                        request.getParameter("idUsuario")
                );

                String estado = request.getParameter("estado");

                String info = request.getParameter("info");

                if(info == null || info.trim().isEmpty()){

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
                        "AdministracionPaciente?mensaje=estado_ok"
                );

            return;
            }
        }
        catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "AdministracionPaciente?mensaje=error"
            );
        }
    }
}
