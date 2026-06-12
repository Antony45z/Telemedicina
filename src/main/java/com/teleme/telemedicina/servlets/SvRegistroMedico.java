package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.UsuarioDAO;
import dao.MedicoDAO;
import modelo.Usuario;
import modelo.Medico;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/SvRegistroMedico")
public class SvRegistroMedico extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = Conexion.getConexion();
            if (con == null) throw new SQLException("No se pudo obtener la conexión a la base de datos.");
            con.setAutoCommit(false);

            // Detectar si viene idMedico (modo edición) o no (modo nuevo)
            String idMedicoStr = request.getParameter("idMedico");
            boolean esEdicion = (idMedicoStr != null && !idMedicoStr.isEmpty());
            int idMedico = esEdicion ? Integer.parseInt(idMedicoStr) : 0;

            // Campos comunes
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("correo");
            String password = request.getParameter("password"); // solo usado en nuevo registro o si implementas cambio de pass
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String tipoDocumento = request.getParameter("tipoDocumento");
            String numeroDocumento = request.getParameter("numeroDocumento");
            String genero = request.getParameter("genero");
            String fechaStr = request.getParameter("fechaNacimiento");
            LocalDate fechaNacimiento = (fechaStr != null && !fechaStr.isEmpty()) ? LocalDate.parse(fechaStr) : null;

            String nroColegiatura = request.getParameter("nroColegiatura");
            String especialidad = request.getParameter("especialidad");
            String aniosStr = request.getParameter("aniosExperiencia");
            int aniosExperiencia = (aniosStr != null && !aniosStr.isEmpty()) ? Integer.parseInt(aniosStr) : 0;
            String centroLaboral = request.getParameter("centroLaboral");
            String descripcion = request.getParameter("descripcion");

            UsuarioDAO usuarioDAO = new UsuarioDAO(con);
            MedicoDAO medicoDAO = new MedicoDAO(con);

            if (!esEdicion) {
                // REGISTRO NUEVO: crear usuario y luego crear medico
                Usuario usuario = new Usuario(nombres, apellidos, correo, password, telefono, direccion,
                        tipoDocumento, numeroDocumento, genero, fechaNacimiento, "MEDICO", null,"Activo",null,0);

                int idUsuario = usuarioDAO.registrarUsuario(usuario);
                if (idUsuario <= 0) {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al registrar el usuario.");
                    request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
                    return;
                }

                Medico medico = new Medico(idUsuario, nroColegiatura, especialidad, aniosExperiencia, centroLaboral, descripcion);
                boolean exitoMedico = medicoDAO.registrarMedico(medico);

                if (exitoMedico) {
                    con.commit();
                    response.sendRedirect("AdministracionMedico?mensaje=registrado_ok");
                } else {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al registrar los datos del médico.");
                    request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
                }
            } else {
                // EDICIÓN: actualizar usuario y médico (usamos el idUsuario existente)
                Medico medicoExistente = medicoDAO.obtenerPorId(idMedico);
                if (medicoExistente == null) {
                    con.rollback();
                    request.setAttribute("mensaje", "⚠️ No se encontró el médico a editar.");
                    request.getRequestDispatcher("AdministracionMedico.jsp").forward(request, response);
                    return;
                }

                Usuario usuario = new Usuario();
                usuario.setIdUsuario(medicoExistente.getIdUsuario());
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

                Medico medico = new Medico();
                medico.setIdMedico(idMedico);
                medico.setIdUsuario(medicoExistente.getIdUsuario());
                medico.setNroColegiatura(nroColegiatura);
                medico.setEspecialidad(especialidad);
                medico.setAniosExperiencia(aniosExperiencia);
                medico.setCentroLaboral(centroLaboral);
                medico.setDescripcion(descripcion);

                boolean actualizadoMedico = medicoDAO.actualizarMedico(medico);

                if (actualizadoUsuario && actualizadoMedico) {
                    con.commit();
                    response.sendRedirect("AdministracionMedico?mensaje=actualizado_ok");
                } else {
                    con.rollback();
                    request.setAttribute("mensaje", "❌ Error al actualizar los datos del médico.");
                    request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            request.setAttribute("mensaje", "⚠️ Error: " + e.getMessage());
            request.getRequestDispatcher("FormularioMedico.jsp").forward(request, response);
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ignored) {}
        }
    }
}
