package com.teleme.telemedicina.servlets;

import dao.Conexion;
import modelo.Diagnostico;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "SvVideoConsulta", urlPatterns = {"/SvVideoConsulta"})
public class SvVideoConsulta extends HttpServlet {

    // ================================
    //     MÉDICO: MOSTRAR VISTA (GET)
    // ================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ticket = request.getParameter("ticket");
        int idCita = 0;

        try {
            idCita = Integer.parseInt(request.getParameter("idCita"));
        } catch (Exception e) {
            // parámetro inválido
        }

        Diagnostico diag = null;

        if (idCita > 0) {
            try (Connection con = Conexion.getConexion()) {

                String sql = "SELECT id_cita, descripcion, receta,tratamiento FROM diagnosticos WHERE id_cita = ?";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, idCita);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        diag = new Diagnostico();
                        diag.setIdCita(rs.getInt("id_cita"));
                        diag.setDescripcion(rs.getString("descripcion"));
                        diag.setReceta(rs.getString("receta"));
                        diag.setTratamiento(rs.getString("tratamiento"));//nuevo
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("diagnostico", diag);
        request.setAttribute("ticket", ticket);
        request.setAttribute("idCita", idCita);

        request.getRequestDispatcher("VideoConsultaMedico.jsp").forward(request, response);
    }

    // ======================================
    //     MÉDICO: GUARDAR DIAGNÓSTICO (POST)
    // ======================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int idCita = 0;
        try {
            idCita = Integer.parseInt(request.getParameter("idCita"));
        } catch (Exception e) {}

        String descripcion = request.getParameter("descripcion");
        String receta = request.getParameter("receta");
        String ticket = request.getParameter("ticket");
        String origen = request.getParameter("origen");
        String tratamiento=request.getParameter("tratamiento");//nuevo

        if (idCita == 0 || descripcion == null || receta == null) {
            response.sendRedirect("Error.jsp");
            return;
        }

        try (Connection con = Conexion.getConexion()) {

            // ------------------------------
            //  ¿EXISTE DIAGNÓSTICO?
            // ------------------------------
            boolean existeDiagnostico = false;
            String sqlCheck = "SELECT COUNT(*) FROM diagnosticos WHERE id_cita = ?";
            try (PreparedStatement psCheck = con.prepareStatement(sqlCheck)) {
                psCheck.setInt(1, idCita);
                ResultSet rs = psCheck.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    existeDiagnostico = true;
                }
            }

            // ------------------------------
            //  ACTUALIZAR O INSERTAR
            // ------------------------------
            if (existeDiagnostico) {
                String sqlUpdate = "UPDATE diagnosticos SET descripcion = ?, receta = ?,tratamiento=? WHERE id_cita = ?";
                try (PreparedStatement psUpdate = con.prepareStatement(sqlUpdate)) {
                    psUpdate.setString(1, descripcion);
                    psUpdate.setString(2, receta);
                    psUpdate.setString(3,tratamiento); //nuevo
                    psUpdate.setInt(4, idCita);
                
                    psUpdate.executeUpdate();
                }

            } else {
                String sqlInsert = "INSERT INTO diagnosticos (id_cita, descripcion, receta,tratamiento) VALUES (?, ?, ?,?)";
                try (PreparedStatement psInsert = con.prepareStatement(sqlInsert)) {
                    psInsert.setInt(1, idCita);
                    psInsert.setString(2, descripcion);
                    psInsert.setString(3, receta);
                    psInsert.setString(4, tratamiento);//nuevo
                    psInsert.executeUpdate();
                }
            }

            // ---------------------------------------------
            //  CAMBIAR ESTADO DE LA CITA A "COMPLETADA"
            // ---------------------------------------------
            String sqlActualizarCita = "UPDATE citas SET estado = 'Completada', hora_fin = NOW() WHERE id_cita = ?";
            try (PreparedStatement psCita = con.prepareStatement(sqlActualizarCita)) {
                psCita.setInt(1, idCita);
                psCita.executeUpdate();
            }

            // ------------------------------
            //  REDIRECCIÓN SEGÚN ORIGEN
            // ------------------------------
            if ("videoconsulta".equalsIgnoreCase(origen)) {
                response.sendRedirect("SvVideoConsulta?idCita=" + idCita + "&ticket=" + ticket + "&success=1");
            } else {
                response.sendRedirect("SvCitasCompletadasMedico");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Error.jsp");
        }
    }
}
