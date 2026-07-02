package com.teleme.telemedicina.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.CitaDAO;
import dao.PacienteDAO;
import dao.Conexion;
import modelo.Cita;
import modelo.Paciente;
import modelo.Usuario;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/SvRegistrarCita")
public class SvRegistrarCita extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // Establecer codificación para manejar acentos correctamente
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Obtener usuario de la sesión
            HttpSession session = request.getSession();
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            if (usuario == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            // 2. Obtener idPaciente desde el DAO
            PacienteDAO pacienteDAO = new PacienteDAO(Conexion.getConexion());
            Paciente paciente = pacienteDAO.obtenerPorUsuario(usuario.getIdUsuario());
            if (paciente == null) {
                request.setAttribute("mensaje", "❌ No se encontró información del paciente.");
                request.getRequestDispatcher("AgendarCitaPaciente.jsp").forward(request, response);
                return;
            }
            int idPaciente = paciente.getIdPaciente();

            // 3. Obtener idMedico y otros datos del formulario
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            String fechaStr = request.getParameter("fecha");
            String horaStr = request.getParameter("hora");
            String motivo = request.getParameter("motivo");
            if (horaStr == null || horaStr.isEmpty()
                    || motivo == null || motivo.isEmpty()) {

                request.setAttribute("idMedico", idMedico);
                request.getRequestDispatcher("AgendarCitaPaciente.jsp")
                       .forward(request, response);

                return;
            }
            
            //Control de ingreso para fechas pasadas 
            if (fechaStr != null && !fechaStr.isEmpty()) {
            // La fecha que viene del formulario (YYYY-MM-DD)
            java.time.LocalDate fechaSeleccionadaCita = java.time.LocalDate.parse(fechaStr);
            java.time.LocalDate hoy = java.time.LocalDate.now();
            
                // Si la fecha seleccionada es anterior a hoy
                if (fechaSeleccionadaCita.isBefore(hoy)) {
                    request.setAttribute("mensaje", "❌ No se pueden agendar citas en fechas pasadas.");
                    request.setAttribute("idMedico", idMedico);
                    // Retornamos al formulario mostrando el error
                    request.getRequestDispatcher("AgendarCitaPaciente.jsp").forward(request, response);
                    return;
                }
            }
            
            // 4. Concatenar fecha y hora
            String fechaCompletaStr = fechaStr + " " + horaStr;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date fechaCita = sdf.parse(fechaCompletaStr);

            // 5. Generar ticket único
            int numero = (int)(Math.random() * 900000) + 100000;
            String ticket = "vmc-" + numero;

            // 6. Crear objeto Cita
            Cita cita = new Cita();
            cita.setIdMedico(idMedico);
            cita.setIdPaciente(idPaciente);
            cita.setFechaCita(fechaCita);
            cita.setMotivo(motivo);
            cita.setEstado("Pendiente"); // Estado por defecto
            cita.setTicket(ticket);
            cita.setFechaRegistro(new Date()); // Fecha de registro actual

            // 7. Guardar la cita en la BD
            CitaDAO citaDAO = new CitaDAO();
            if (citaDAO.existeCitaMedicoEnHora(idMedico, fechaCita)) {
                request.setAttribute("mensaje",
                    "❌ La hora seleccionada ya fue reservada.");
                request.setAttribute("idMedico", idMedico);
                request.getRequestDispatcher("AgendarCitaPaciente.jsp")
                       .forward(request, response);
                return;
            }
            boolean exito = citaDAO.agendarCita(cita);
            
            // 8. Enviar mensaje al JSP
            if (exito) {
                request.setAttribute("mensaje", "✅ Cita agendada exitosamente. Ticket: " + ticket);
            } else {
                request.setAttribute("mensaje", "❌ No se pudo agendar la cita. Intente nuevamente.");
            }

            // 9. Mantener idMedico en el formulario
            request.setAttribute("idMedico", idMedico);

            // 10. Forward al JSP
            request.getRequestDispatcher("AgendarCitaPaciente.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("mensaje", "❌ Ocurrió un error. Intente nuevamente.");
            request.getRequestDispatcher("AgendarCitaPaciente.jsp").forward(request, response);
        }
    }
}
