package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.PacienteDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.math.BigDecimal; // 👈 NECESARIO para peso y altura
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelo.Paciente;

@WebServlet(name = "SvActualizarPaciente", urlPatterns = {"/SvActualizarPaciente"})
public class SvActualizarPaciente extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Obtener parámetros del formulario
        // Datos de Paciente
        int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
        String historialClinico = request.getParameter("historialClinico");
        String alergias = request.getParameter("alergias");
        String grupoSanguineo = request.getParameter("grupoSanguineo");
        
        String pesoParam = request.getParameter("peso");
        String alturaParam = request.getParameter("altura");
        
        BigDecimal peso = null;
        BigDecimal altura = null;
        
        // 1. Validar y convertir Peso
        if (pesoParam != null && !pesoParam.trim().isEmpty()) {
            try {
                // Usamos trim() para limpiar espacios
                peso = new BigDecimal(pesoParam.trim()); 
            } catch (NumberFormatException e) {
                response.sendRedirect("PerfilPaciente.jsp?error=format_peso");
                return; // Detiene la ejecución si el formato es incorrecto
            }
        }
        
        // 2. Validar y convertir Altura
        if (alturaParam != null && !alturaParam.trim().isEmpty()) {
            try {
                altura = new BigDecimal(alturaParam.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect("PerfilPaciente.jsp?error=format_altura");
                return; // Detiene la ejecución si el formato es incorrecto
            }
        }
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");

        try (Connection con = Conexion.getConexion()) {
            PacienteDAO pacienteDAO = new PacienteDAO(con);

            // 2️⃣ Obtener el paciente actual
            Paciente paciente = pacienteDAO.obtenerPorId(idPaciente);
            
            if (paciente == null) {
                response.sendRedirect("PerfilPaciente.jsp?error=notfound");
                return;
            }

            // 3️⃣ Actualizar campos en el objeto Paciente
            paciente.setNombre(nombre);
            paciente.setApellido(apellido);
            paciente.setCorreo(correo);
            paciente.setTelefono(telefono);
            
            paciente.setHistorialClinico(historialClinico);
            paciente.setAlergias(alergias);
            paciente.setGrupoSanguineo(grupoSanguineo);
            paciente.setPeso(peso);     // Asigna BigDecimal (puede ser null)
            paciente.setAltura(altura);

            // 4️⃣ Actualizar en BD (tabla pacientes)
            boolean actualizado = pacienteDAO.actualizarPaciente(paciente); 

            // 5️⃣ Actualizar tabla usuarios (nombre, correo, etc.)
            if (actualizado) {
                String sql = "UPDATE usuarios SET nombre=?, apellido=?, correo_electronico=?, telefono=? WHERE id_usuario=?";
                try (var ps = con.prepareStatement(sql)) {
                    ps.setString(1, nombre);
                    ps.setString(2, apellido);
                    ps.setString(3, correo);
                    ps.setString(4, telefono);
                    System.out.println("ID Usuario a actualizar: " + paciente.getIdUsuario());
                    ps.setInt(5, paciente.getIdUsuario()); 
                    ps.executeUpdate();
                }
            }

            // 6️⃣ Actualizar sesión y redirigir
            Paciente pacienteActualizado = pacienteDAO.obtenerPorId(idPaciente); 
            
            HttpSession sesion = request.getSession();
            sesion.setAttribute("paciente", pacienteActualizado); 
            
            if (actualizado) {
                response.sendRedirect("PerfilPaciente.jsp?exito=1");
            } else {
                response.sendRedirect("PerfilPaciente.jsp?error=1");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("PerfilPaciente.jsp?error=sql");
        }
    }
}