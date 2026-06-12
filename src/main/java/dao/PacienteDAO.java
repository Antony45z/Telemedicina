package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import modelo.Paciente;

public class PacienteDAO {
    private final Connection con;

    public PacienteDAO(Connection con) {
        this.con = con;
    }

    //  REGISTRAR PACIENTE
   public boolean registrarPaciente(Paciente p) throws SQLException {
    String sql = "{CALL SP_RegistrarPaciente(?, ?, ?, ?, ?, ?)}";

    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, p.getIdUsuario());
        cs.setString(2, p.getHistorialClinico());
        cs.setString(3, p.getAlergias());
        cs.setString(4, p.getGrupoSanguineo());
        cs.setBigDecimal(5, p.getPeso());
        cs.setBigDecimal(6, p.getAltura());
        
        return cs.executeUpdate() > 0;
    }
}


    //  LISTAR PACIENTES 
    public List<Paciente> listarPacientes() throws SQLException {
    List<Paciente> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarPacientes()}";

    try (CallableStatement cs = con.prepareCall(sql);
         ResultSet rs = cs.executeQuery()) {

        while (rs.next()) {
            Paciente p = new Paciente();
            p.setIdPaciente(rs.getInt("id_paciente"));
            p.setIdUsuario(rs.getInt("id_usuario"));
            p.setHistorialClinico(rs.getString("historial_clinico"));
            p.setAlergias(rs.getString("alergias"));
            p.setGrupoSanguineo(rs.getString("grupo_sanguineo"));
            p.setPeso(rs.getBigDecimal("peso"));
            p.setAltura(rs.getBigDecimal("altura"));
            p.setNombre(rs.getString("nombre"));
            p.setApellido(rs.getString("apellido"));
            p.setCorreo(rs.getString("correo_electronico"));
            p.setTelefono(rs.getString("telefono"));
            p.setEstado(rs.getString("estado"));
            p.setInfo(rs.getString("info"));
            lista.add(p);
        }
    }

    return lista;
}


    //  OBTENER PACIENTE POR ID_USUARIO (objeto completo)
    public Paciente obtenerPorUsuario(int idUsuario) throws SQLException {
    String sql = "{CALL sp_obtener_paciente_por_usuario(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idUsuario);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                Paciente p = new Paciente();
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setHistorialClinico(rs.getString("historial_clinico"));
                p.setAlergias(rs.getString("alergias"));
                p.setGrupoSanguineo(rs.getString("grupo_sanguineo"));
                p.setPeso(rs.getBigDecimal("peso"));
                p.setAltura(rs.getBigDecimal("altura"));
                
                
                
                return p;
            }
        }
    }
    return null;
}


    // OBTENER SOLO EL ID_PACIENTE POR ID_USUARIO (para sesión en SvLogin)
   public int obtenerIdPorUsuario(int idUsuario) throws SQLException {
    String sql = "{CALL sp_obtener_id_paciente_por_usuario(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idUsuario);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_paciente");
            }
        }
    }
    return -1; // No encontrado
}


    // OBTENER PACIENTE POR ID
    public Paciente obtenerPorId(int idPaciente) throws SQLException {
    String sql = "{CALL sp_obtener_paciente_por_id(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idPaciente);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                Paciente p = new Paciente();
                p.setIdPaciente(rs.getInt("id_paciente"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setHistorialClinico(rs.getString("historial_clinico"));
                p.setAlergias(rs.getString("alergias"));
                p.setGrupoSanguineo(rs.getString("grupo_sanguineo"));
                p.setPeso(rs.getBigDecimal("peso"));
                p.setAltura(rs.getBigDecimal("altura"));
                p.setNombre(rs.getString("nombre"));
                p.setApellido(rs.getString("apellido"));
                p.setCorreo(rs.getString("correo_electronico"));
                p.setTelefono(rs.getString("telefono"));
                p.setEstado(rs.getString("estado"));
                p.setInfo(rs.getString("info"));

                return p;
            }
        }
    }
    return null;
}


    //  ACTUALIZAR PACIENTE
    public boolean actualizarPaciente(Paciente p) throws SQLException {
    String sql = "{CALL sp_actualizar_paciente(?, ?, ?, ?, ?, ?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, p.getIdPaciente());
        cs.setString(2, p.getHistorialClinico());
        cs.setString(3, p.getAlergias());
        cs.setString(4, p.getGrupoSanguineo());
        cs.setBigDecimal(5, p.getPeso());
        cs.setBigDecimal(6, p.getAltura());
        return cs.executeUpdate() > 0;
    }
}


    // ELIMINAR PACIENTE + USUARIO ASOCIADO
    public boolean eliminarPaciente(int idPaciente) throws SQLException {
    String sql = "{CALL sp_eliminar_paciente(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idPaciente);
        return cs.executeUpdate() > 0;
    }
}

}
