package com.teleme.telemedicina.servlets;

// IMPORTAMOS LA NUEVA CLASE DE VALIDACIÓN PARA EL REGISTRO
import PRUEBASUNITARIAS.ValidacionesRegistro;

import dao.Conexion;
import dao.UsuarioDAO;
import dao.PacienteDAO;
import dao.MedicoDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Usuario;
import modelo.Paciente;
import modelo.Medico;
import at.favre.lib.crypto.bcrypt.BCrypt;

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    // INSTANCIAMOS EL OBJETO DE VALIDACIONES DE REGISTRO
    private final ValidacionesRegistro validador = new ValidacionesRegistro();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        try {
            con = Conexion.getConexion();
            if (con == null) throw new SQLException("No se pudo obtener la conexión a la base de datos");
            con.setAutoCommit(false);

            // 1) Datos del formulario
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String correo = request.getParameter("email");
            String password = request.getParameter("password");
            //ENCRIPTAR PASSWORD CON BCRYPT
            String passwordEncriptada =
                    BCrypt.withDefaults()
                    .hashToString(12, password.toCharArray());
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String tipoDocumento = request.getParameter("tipoDocumento");
            String numeroDocumento = request.getParameter("numeroDocumento");
            String genero = request.getParameter("genero");
            String fechaStr = request.getParameter("fechaNacimiento");
            LocalDate fechaNacimiento = (fechaStr != null && !fechaStr.isEmpty())
                    ? LocalDate.parse(fechaStr) : null;
            
            String rol = request.getParameter("tipoUsuario"); // PACIENTE o MEDICO

            Usuario usuario = new Usuario(
                    nombres, apellidos, correo, passwordEncriptada, telefono, direccion,
                    tipoDocumento, numeroDocumento, genero, fechaNacimiento, rol, null, "Activo", null, 0
            );

            // 2) Registrar usuario
            UsuarioDAO usuarioDAO = new UsuarioDAO(con);
            int idUsuario = usuarioDAO.registrarUsuario(usuario);

            boolean exitoDetalle = false;

            // PRUEBA 8: Validamos si el ID generado permite continuar con la lógica
            if (validador.puedeContinuarConDetalles(idUsuario)) {
                
                // PRUEBA 6: Evaluamos la asignación y el flujo exacto según el rol sanitizado
                String flujoRol = validador.determinarFlujoPorRol(rol);

                if ("PROCESAR_DETALLE_PACIENTE".equals(flujoRol)) {
                    String grupoSanguineo = request.getParameter("grupoSanguineo");
                    String allergies = request.getParameter("alergias");
                    String historialClinico = request.getParameter("historialClinico");

                    BigDecimal peso = (request.getParameter("peso") != null && !request.getParameter("peso").isEmpty())
                            ? new BigDecimal(request.getParameter("peso")) : null;

                    BigDecimal altura = (request.getParameter("altura") != null && !request.getParameter("altura").isEmpty())
                            ? new BigDecimal(request.getParameter("altura")) : null;

                    Paciente paciente = new Paciente(idUsuario, historialClinico, allergies, grupoSanguineo, peso, altura);
                    exitoDetalle = new PacienteDAO(con).registrarPaciente(paciente);

                } else if ("PROCESAR_DETALLE_MEDICO".equals(flujoRol)) {
                    String nroColegiatura = request.getParameter("numeroColegiatura");
                    String especialidad = request.getParameter("especialidad");
                    
                    // PRUEBA 7: Evaluamos y corregimos los años de experiencia de manera segura
                    String experienciaStr = request.getParameter("aniosExperiencia");
                    int aniosExperiencia = validador.evaluarAniosExperiencia(experienciaStr);
                    
                    String centroLaboral = request.getParameter("centroLaboral");
                    String descripcion = request.getParameter("descripcion");

                    Medico medico = new Medico(idUsuario, nroColegiatura, especialidad, aniosExperiencia, centroLaboral, descripcion);
                    exitoDetalle = new MedicoDAO(con).registrarMedico(medico);
                }

                // 3) Confirmar o revertir transacción
                if (exitoDetalle) {
                    con.commit();
    request.setAttribute("registroExitoso", true);
    request.getRequestDispatcher("registro.jsp").forward(request, response);
    return;
                } else {
                    con.rollback();
                    request.setAttribute("mensaje", "Error al registrar los datos adicionales. Intenta nuevamente.");
                    request.setAttribute("tipoMensaje", "danger");
                    request.getRequestDispatcher("registro.jsp").forward(request, response);
                    return;
                }
            } else {
                con.rollback();
                request.setAttribute("mensaje", "Error al registrar el usuario (ID inválido generado). Intenta nuevamente.");
                request.setAttribute("tipoMensaje", "danger");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
                return;
            }

        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            request.setAttribute("mensaje", "Error: " + e.getMessage());
            request.setAttribute("tipoMensaje", "danger");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
    }
}