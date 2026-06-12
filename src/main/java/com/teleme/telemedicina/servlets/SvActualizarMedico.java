package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.MedicoDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.io.InputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import modelo.Medico;

@WebServlet(name = "SvActualizarMedico", urlPatterns = {"/SvActualizarMedico"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)  // 5 MB
public class SvActualizarMedico extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Datos del formulario
        int idMedico = Integer.parseInt(request.getParameter("idMedico"));
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String especialidad = request.getParameter("especialidad");
        String nroColegiatura = request.getParameter("nroColegiatura");
        int aniosExperiencia = Integer.parseInt(request.getParameter("aniosExperiencia"));
        String centroLaboral = request.getParameter("centroLaboral");
        String descripcion = request.getParameter("descripcion");

        // Foto
        Part fotoPart = request.getPart("fotoPerfil");
        byte[] fotoBytes = null;

        if (fotoPart != null && fotoPart.getSize() > 0) {
            InputStream inputStream = fotoPart.getInputStream();
            fotoBytes = inputStream.readAllBytes();
        }

        try (Connection con = Conexion.getConexion()) {

            MedicoDAO medicoDAO = new MedicoDAO(con);

            // 2️ Obtener médico actual
            Medico medico = medicoDAO.obtenerPorId(idMedico);

            if (medico == null) {
                response.sendRedirect("PerfilMedico.jsp?error=notfound");
                return;
            }

            // 3️ Actualizar campos en el objeto
            medico.setNombre(nombre);
            medico.setApellido(apellido);
            medico.setCorreo(correo);
            medico.setTelefono(telefono);
            medico.setEspecialidad(especialidad);
            medico.setNroColegiatura(nroColegiatura);
            medico.setAniosExperiencia(aniosExperiencia);
            medico.setCentroLaboral(centroLaboral);
            medico.setDescripcion(descripcion);

            if (fotoBytes != null) {
                medico.setFotoPerfil(fotoBytes);   // <= Esto va a la BD
            }

            // 4️ Actualizar tabla medico
            boolean actualizado = medicoDAO.actualizarMedico(medico);

            // 5️ Actualizar tabla usuarios
            if (actualizado) {
            String sql = "UPDATE usuarios SET nombre=?, apellido=?, correo_electronico=?, telefono=?, foto_perfil=? WHERE id_usuario=?";

            try (var ps = con.prepareStatement(sql)) {
                ps.setString(1, nombre);
                ps.setString(2, apellido);
                ps.setString(3, correo);
                ps.setString(4, telefono);

                if (fotoBytes != null) {
    ps.setBytes(5, fotoBytes); 
} else {
    ps.setBytes(5, medico.getFotoPerfil()); 
}


                ps.setInt(6, medico.getIdUsuario()); // ID del usuario

                ps.executeUpdate();
            }
        }


            // 6️ Refrescar sesión
            HttpSession sesion = request.getSession();
            sesion.setAttribute("medico", medico);

            response.sendRedirect(actualizado ? "PerfilMedico.jsp?exito=1" : "PerfilMedico.jsp?error=1");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("PerfilMedico.jsp?error=sql");
        }
    }
}
