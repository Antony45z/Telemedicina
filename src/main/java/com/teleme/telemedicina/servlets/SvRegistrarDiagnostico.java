package com.teleme.telemedicina.servlets;
import dao.Conexion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "SvRegistrarDiagnostico", urlPatterns = {"/SvRegistrarDiagnostico"})
public class SvRegistrarDiagnostico extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idCita = Integer.parseInt(request.getParameter("idCita"));
        String descripcion = request.getParameter("descripcion");
        String receta = request.getParameter("receta");
        String tratamiento=request.getParameter("tratamiento");//nuevo

        try (Connection con = Conexion.getConexion()) {

            // Verificar si ya existe diagnóstico para esta cita
            String sqlCheck = "SELECT COUNT(*) FROM diagnosticos WHERE id_cita = ?";
            boolean existeDiagnostico = false;

            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, idCita);
                ResultSet rs = psCheck.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    existeDiagnostico = true;
                }
            }

            // Si existe → actualizar, si no → insertar
            if (existeDiagnostico) {
                String sqlUpdate = "UPDATE diagnosticos SET descripcion = ?, receta = ?,tratamiento=? WHERE id_cita = ?";
                try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                    psUpdate.setString(1, descripcion);
                    psUpdate.setString(2, receta);
                    psUpdate.setString(3, tratamiento); //nuevo
                    psUpdate.setInt(4, idCita);
                    psUpdate.executeUpdate();
                    System.out.println("✅ Diagnóstico actualizado correctamente");
                }
            } else {
                String sqlInsert = "INSERT INTO diagnosticos (id_cita, descripcion, receta,tratamiento) VALUES (?, ?, ?,?)";
                try (PreparedStatement psInsert = con.prepareStatement(sqlInsert)) {
                    psInsert.setInt(1, idCita);
                    psInsert.setString(2, descripcion);
                    psInsert.setString(3, receta);
                    psInsert.setString(4, tratamiento);//nuevo
                    psInsert.executeUpdate();
                    System.out.println(" Diagnóstico insertado correctamente");
                }
            }           

            String origen = request.getParameter("origen"); // "videoconsulta" o "normal"

            // Después de guardar o actualizar el diagnóstico
            if ("videoconsulta".equals(origen)) {
                // Quedarse en la misma página
                response.sendRedirect("VideoConsultaMedico.jsp?ticket=" + request.getParameter("ticket") + "&idCita=" + idCita + "&success=1");
            } else {
                // Comportamiento original
                response.sendRedirect("SvCitasCompletadasMedico");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Error.jsp");
        }
    }
}
