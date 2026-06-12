package dao;

import modelo.Diagnostico;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DiagnosticoDAO {

    //  LISTAR DIAGNÓSTICOS DE UN PACIENTE
   public List<Diagnostico> listarDiagnosticosPorPaciente(int idPaciente) {
    List<Diagnostico> diagnosticos = new ArrayList<>();
    String sql = "{CALL SP_ListarDiagnosticosPorPaciente(?)}"; // llamada al procedimiento

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) { // 🔹 CAMBIO 1: usar CallableStatement

        cs.setInt(1, idPaciente);
        try (ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Diagnostico diag = new Diagnostico();
                diag.setIdDiagnostico(rs.getInt("id_diagnostico"));
                diag.setIdCita(rs.getInt("id_cita"));
                diag.setDescripcion(rs.getString("descripcion"));
                diag.setReceta(rs.getString("receta"));
                diag.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                diag.setTicket(rs.getString("ticket")); // 🔹 CAMBIO 2: agregar el campo 'ticket'
                diagnosticos.add(diag);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar diagnósticos del paciente: " + e.getMessage());
        e.printStackTrace();
    }

    return diagnosticos;
}

    //  LISTAR DIAGNÓSTICOS DE UN MÉDICO
public List<Diagnostico> listarDiagnosticosPorMedico(int idMedico) {
    List<Diagnostico> diagnosticos = new ArrayList<>();
    String sql = "{CALL SP_ListarDiagnosticosPorMedico(?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, idMedico);
        try (ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Diagnostico diag = new Diagnostico();
                diag.setIdDiagnostico(rs.getInt("id_diagnostico"));
                diag.setIdCita(rs.getInt("id_cita"));
                diag.setDescripcion(rs.getString("descripcion"));
                diag.setReceta(rs.getString("receta"));
                diag.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                diagnosticos.add(diag);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar diagnósticos del médico: " + e.getMessage());
        e.printStackTrace();
    }

    return diagnosticos;
}


}
