package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.UsuarioDAO;
import dao.PacienteDAO;
import modelo.Usuario;
import modelo.Paciente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.math.BigDecimal;

@WebServlet("/SvRegistroPaciente")
public class SvRegistroPaciente extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         Connection con = null;
        try {
            con = Conexion.getConexion();
            if (con == null) throw new SQLException("No se pudo obtener la conexión a la base de datos.");
            con.setAutoCommit(false);

            // Detectar si es edición o registro nuevo
            String idPacienteStr = request.getParameter("idPaciente");
            boolean esEdicion = idPacienteStr != null && !idPacienteStr.isEmpty();
            int idPaciente = esEdicion ? Integer.parseInt(idPacienteStr) : 0;

            // Datos comunes
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password"); // solo en registro
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String tipoDocumento = request.getParameter("tipoDocumento");
            String numeroDocumento = request.getParameter("numeroDocumento");
            String genero = request.getParameter("genero");
            String fechaStr = request.getParameter("fechaNacimiento");
            LocalDate fechaNacimiento = (fechaStr != null && !fechaStr.isEmpty()) ? LocalDate.parse(fechaStr) : null;

            // Datos específicos del paciente
            String historialClinico = request.getParameter("historialClinico");
            String alergias = request.getParameter("alergias");
            String grupoSanguineo = request.getParameter("grupoSanguineo");

            BigDecimal peso = parseBigDecimal(request.getParameter("peso"));
            BigDecimal altura = parseBigDecimal(request.getParameter("altura"));

            UsuarioDAO usuarioDAO = new UsuarioDAO(con);
            PacienteDAO pacienteDAO = new PacienteDAO(con);

            if (!esEdicion) {
                // 🆕 REGISTRO NUEVO
                Usuario usuario = new Usuario(
                        nombres, apellidos, correo, password, telefono, direccion,
                        tipoDocumento, numeroDocumento, genero, fechaNacimiento, "PACIENTE", null,"Activo",null,0
                );

                int idUsuario = usuarioDAO.registrarUsuario(usuario);
                if (idUsuario <= 0) {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al registrar el usuario.");
                    request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
                    return;
                }

                Paciente paciente = new Paciente(idUsuario, historialClinico, alergias, grupoSanguineo, peso, altura);
                boolean exitoPaciente = pacienteDAO.registrarPaciente(paciente);

                if (exitoPaciente) {
                    con.commit();
                    response.sendRedirect("AdministracionPaciente?mensaje=registrado_ok");
                } else {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al registrar los datos del paciente.");
                    request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
                }

            } else {
                // ✏️ EDICIÓN EXISTENTE
                Paciente pacienteExistente = pacienteDAO.obtenerPorId(idPaciente);
                if (pacienteExistente == null) {
                    con.rollback();
                    request.setAttribute("mensaje", "⚠️ No se encontró el paciente a editar.");
                    request.getRequestDispatcher("AdministracionPaciente.jsp").forward(request, response);
                    return;
                }

                Usuario usuario = new Usuario();
                usuario.setIdUsuario(pacienteExistente.getIdUsuario());
                usuario.setNombre(nombres);
                usuario.setApellido(apellidos);
                usuario.setCorreo(correo);
                usuario.setTelefono(telefono);
                usuario.setDireccion(direccion);
                usuario.setTipoDocumento(tipoDocumento);
                usuario.setNumeroDocumento(numeroDocumento);
                usuario.setGenero(genero);
                usuario.setFechaNacimiento(fechaNacimiento);

                boolean actualizadoUsuario = usuarioDAO.actualizarUsuario(usuario);

                Paciente paciente = new Paciente();
                paciente.setIdPaciente(idPaciente);
                paciente.setIdUsuario(pacienteExistente.getIdUsuario());
                paciente.setHistorialClinico(historialClinico);
                paciente.setAlergias(alergias);
                paciente.setGrupoSanguineo(grupoSanguineo);
                paciente.setPeso(peso);
                paciente.setAltura(altura);

                boolean actualizadoPaciente = pacienteDAO.actualizarPaciente(paciente);

                if (actualizadoUsuario && actualizadoPaciente) {
                    con.commit();
                    response.sendRedirect("AdministracionPaciente?mensaje=actualizado_ok");
                } else {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al actualizar los datos del paciente.");
                    request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            request.setAttribute("mensaje", "⚠️ Error: " + e.getMessage());
            request.getRequestDispatcher("FormularioPaciente.jsp").forward(request, response);
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ignored) {}
        }
    }

    // Método auxiliar para convertir string a BigDecimal de forma segura
    private BigDecimal parseBigDecimal(String value) {
        try {
            return (value != null && !value.isEmpty()) ? new BigDecimal(value) : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
