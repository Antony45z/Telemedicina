package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Medico;

public class MedicoDAO {
    private final Connection con;

    public MedicoDAO(Connection con) {
        this.con = con;
    }

    public MedicoDAO() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // REGISTRAR MÉDICO
   public boolean registrarMedico(Medico m) throws SQLException {
    String sql = "{CALL SP_RegistrarMedico(?, ?, ?, ?, ?, ?)}";
    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, m.getIdUsuario());
        ps.setString(2, m.getNroColegiatura());
        ps.setString(3, m.getEspecialidad());
        ps.setInt(4, m.getAniosExperiencia());
        ps.setString(5, m.getCentroLaboral());
        ps.setString(6, m.getDescripcion());
        return ps.executeUpdate() > 0;
    }
}


    // 🔹 LISTAR TODOS LOS MÉDICOS
   public List<Medico> listarMedicos() throws SQLException {
    List<Medico> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarMedicos()}";

    try (CallableStatement cs = con.prepareCall(sql);
         ResultSet rs = cs.executeQuery()) {
        while (rs.next()) {
            Medico m = new Medico();
            m.setIdMedico(rs.getInt("id_medico"));
            m.setIdUsuario(rs.getInt("id_usuario"));
            m.setNroColegiatura(rs.getString("nro_colegiatura"));
            m.setEspecialidad(rs.getString("especialidad"));
            m.setAniosExperiencia(rs.getInt("anios_experiencia"));
            m.setCentroLaboral(rs.getString("centro_laboral"));
            m.setDescripcion(rs.getString("descripcion"));
            m.setNombre(rs.getString("nombre"));
            m.setApellido(rs.getString("apellido"));
            m.setCorreo(rs.getString("correo_electronico"));
            m.setTelefono(rs.getString("telefono"));
            m.setFotoPerfil(rs.getBytes("foto_perfil"));
            m.setEstado(rs.getString("estado"));
            m.setInfo(rs.getString("info"));
            lista.add(m);
        }
    }
    return lista;
}


    //  OBTENER MÉDICO POR ID
    public Medico obtenerPorId(int idMedico) throws SQLException {
    String sql = "{CALL SP_ObtenerMedicoPorId(?)}";

    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idMedico);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("id_medico"));
                m.setIdUsuario(rs.getInt("id_usuario"));
                m.setNroColegiatura(rs.getString("nro_colegiatura"));
                m.setEspecialidad(rs.getString("especialidad"));
                m.setAniosExperiencia(rs.getInt("anios_experiencia"));
                m.setCentroLaboral(rs.getString("centro_laboral"));
                m.setDescripcion(rs.getString("descripcion"));
                m.setNombre(rs.getString("nombre"));
                m.setApellido(rs.getString("apellido"));
                m.setCorreo(rs.getString("correo_electronico"));
                m.setTelefono(rs.getString("telefono"));
                m.setFotoPerfil(rs.getBytes("foto_perfil"));
                m.setEstado(rs.getString("estado"));
                m.setInfo(rs.getString("info"));
                return m;
            }
        }
    }
    return null;
}


    // OBTENER ID DEL MÉDICO POR ID_USUARIO
    public int obtenerIdPorUsuario(int idUsuario) throws SQLException {
    String sql = "{CALL SP_ObtenerIdMedicoPorUsuario(?)}";
    
    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("id_medico");
            }
        }
    }
    return -1; // Si no se encuentra
}


    //  LISTAR MÉDICOS PARA CITA (simplificado)
  public List<Medico> listarMedicosParaCita() throws SQLException {
    List<Medico> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarMedicosParaCita()}";

    try (CallableStatement cs = con.prepareCall(sql);
         ResultSet rs = cs.executeQuery()) {
        while (rs.next()) {
            Medico m = new Medico();
            m.setIdMedico(rs.getInt("id_medico"));
            m.setNombre(rs.getString("nombre"));
            m.setApellido(rs.getString("apellido"));
            m.setEspecialidad(rs.getString("especialidad"));
            m.setCentroLaboral(rs.getString("centro_laboral"));
            lista.add(m);
        }
    }
    return lista;
}


    //  ACTUALIZAR MÉDICO
    public boolean actualizarMedico(Medico m) throws SQLException {
    String sql = "{CALL SP_ActualizarMedico(?, ?, ?, ?, ?, ?)}";

    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, m.getIdMedico());
        ps.setString(2, m.getNroColegiatura());
        ps.setString(3, m.getEspecialidad());
        ps.setInt(4, m.getAniosExperiencia());
        ps.setString(5, m.getCentroLaboral());
        ps.setString(6, m.getDescripcion());
        return ps.executeUpdate() > 0;
    }
}


    // ELIMINAR MÉDICO + USUARIO ASOCIADO
   public boolean eliminarMedico(int idMedico) throws SQLException {
    String sql = "{CALL SP_EliminarMedicoYUsuario(?)}";

    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idMedico);
        return ps.executeUpdate() > 0;
    }
}

    
   public String obtenerNombrePorUsuario(int idUsuario) throws SQLException {
    String sql = "{CALL SP_ObtenerNombrePorUsuario(?)}";
    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, idUsuario);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getString("nombre");
            }
        }
    }
    return "Invitado";
}

    public List<Medico> obtenerTopDoctores() throws SQLException {
    List<Medico> topDoctores = new ArrayList<>();
    String sql = "{CALL SP_ObtenerTopDoctores()}";

    try (PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Medico m = new Medico();
            m.setIdMedico(rs.getInt("id_medico"));
            m.setNombre(rs.getString("nombre"));
            m.setApellido(rs.getString("apellido"));
            m.setEspecialidad(rs.getString("especialidad"));
            try {
                m.setFotoPerfil(rs.getBytes("foto_perfil"));
            } catch (SQLException e) {
                // Si la columna no existe en el SP, no rompemos el flujo, solo queda sin foto
                System.out.println("Advertencia: No se encontró la columna 'foto_perfil' en SP_ObtenerTopDoctores");
            }
            topDoctores.add(m);
        }
    }
    return topDoctores;
}
// MODIFICADO usando el codigo inicial y solo agregando  m.setFotoPerfil(rs.getBytes("foto_perfil"));
public List<Medico> filtrarMedicos(String especialidad) {
    List<Medico> lista = new ArrayList<>();
    // Si no hay filtro, busca a todos
    if (especialidad == null || especialidad.trim().isEmpty()) {
        try { return listarMedicos(); } catch (SQLException e) { e.printStackTrace(); }
    }

    String sql = "SELECT m.id_medico, m.especialidad, m.centro_laboral, u.nombre, u.apellido, u.foto_perfil " +
                 "FROM medicos m INNER JOIN usuarios u ON m.id_usuario = u.id_usuario " +
                 "WHERE m.especialidad LIKE ?";

    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, "%" + especialidad + "%");
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("id_medico"));
                m.setNombre(rs.getString("nombre"));
                m.setApellido(rs.getString("apellido"));
                m.setEspecialidad(rs.getString("especialidad"));
                m.setCentroLaboral(rs.getString("centro_laboral"));
                m.setFotoPerfil(rs.getBytes("foto_perfil"));
                lista.add(m);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        }
        return lista;
    }

    public List<String> listarEspecialidades() {
        List<String> especialidades = new ArrayList<>();
        String sql = "SELECT DISTINCT especialidad FROM medicos WHERE especialidad IS NOT NULL AND especialidad <> ''";

        // QUITAMOS el "try (Connection con = this.con)" porque eso cierra tu conexión global
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                especialidades.add(rs.getString("especialidad"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return especialidades;
    }
//esta es la mnodificacion por  geminis
/*public List<Medico> filtrarMedicos(String especialidad) {
    List<Medico> lista = new ArrayList<>();
    
    // Es mejor especificar las columnas en lugar de * para evitar conflictos de IDs
    String sql = "SELECT m.id_medico, m.especialidad, m.centro_laboral, m.anios_experiencia, m.descripcion, " +
                 "u.nombre, u.apellido, u.correo_electronico, u.telefono, u.foto_perfil " +
                 "FROM medicos m INNER JOIN usuarios u ON m.id_usuario = u.id_usuario " +
                 "WHERE m.especialidad LIKE ?";

    // ⚠️ NOTA IMPORTANTE SOBRE LA CONEXIÓN (Leer abajo)
    try (PreparedStatement ps = con.prepareStatement(sql)) { 

        ps.setString(1, "%" + especialidad + "%");

        try (ResultSet rs = ps.executeQuery()) { // Usar try-with-resources para el ResultSet también
            while (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("id_medico"));
                m.setNombre(rs.getString("nombre"));
                m.setApellido(rs.getString("apellido"));
                m.setEspecialidad(rs.getString("especialidad"));
                m.setCentroLaboral(rs.getString("centro_laboral"));
                m.setAniosExperiencia(rs.getInt("anios_experiencia"));
                m.setDescripcion(rs.getString("descripcion"));
                m.setCorreo(rs.getString("correo_electronico"));
                m.setTelefono(rs.getString("telefono"));
                
                // ✅ ESTA ES LA LÍNEA QUE FALTABA:
                m.setFotoPerfil(rs.getBytes("foto_perfil")); 
                
                lista.add(m);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return lista;
}
*/
}