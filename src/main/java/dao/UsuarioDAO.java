package dao;

import java.sql.*;
import modelo.Usuario;

public class UsuarioDAO {

    private Connection con;

    public UsuarioDAO(Connection con) {
        this.con = con;
    }

    // Buscar usuario por correo
  public Usuario obtenerPorCorreo(String correo) throws SQLException {
    String sql = "{CALL SP_ObtenerUsuarioPorCorreo(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setString(1, correo);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        }
    }
    return null;
}



    // Obtener usuario por ID
  public Usuario obtenerPorId(int idUsuario) throws SQLException {
    String sql = "{CALL SP_ObtenerUsuarioPorId(?)}";
    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idUsuario);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                return mapearUsuario(rs);
            }
        }
    }
    return null;
}


    // Registrar usuario y devolver el ID generado
    public int registrarUsuario(Usuario u) throws SQLException {
    String sql = "{CALL SP_RegistrarUsuario(?,?,?,?,?,?,?,?,?,?,?)}";
    int idGenerado = 0;

    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setString(1, u.getNombre());
        cs.setString(2, u.getApellido());
        cs.setString(3, u.getCorreo());
        cs.setString(4, u.getPassword());
        cs.setString(5, u.getTelefono());
        cs.setString(6, u.getDireccion());
        cs.setString(7, u.getTipoDocumento());
        cs.setString(8, u.getNumeroDocumento());
        cs.setString(9, u.getGenero());

        if (u.getFechaNacimiento() != null) {
            cs.setDate(10, java.sql.Date.valueOf(u.getFechaNacimiento()));
        } else {
            cs.setNull(10, Types.DATE);
        }

        cs.setString(11, u.getRol());

        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                idGenerado = rs.getInt("id_generado");
            }
        }
    }
    return idGenerado;
}


    // Actualizar datos del usuario (sin tocar contraseña)
    public boolean actualizarUsuario(Usuario u) throws SQLException {
    String sql = "{CALL SP_ActualizarUsuario(?,?,?,?,?,?,?,?,?,?)}";

    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, u.getIdUsuario());
        cs.setString(2, u.getNombre());
        cs.setString(3, u.getApellido());
        cs.setString(4, u.getCorreo());
        cs.setString(5, u.getTelefono());
        cs.setString(6, u.getDireccion());
        cs.setString(7, u.getTipoDocumento());
        cs.setString(8, u.getNumeroDocumento());
        cs.setString(9, u.getGenero());

        if (u.getFechaNacimiento() != null) {
            cs.setDate(10, java.sql.Date.valueOf(u.getFechaNacimiento()));
        } else {
            cs.setNull(10, Types.DATE);
        }

        return cs.executeUpdate() > 0;
    }
}


    // Actualizar contraseña (por separado)
    public boolean actualizarPassword(int idUsuario, String nuevaPassword) throws SQLException {
    String sql = "{CALL SP_ActualizarPassword(?,?)}";

    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idUsuario);
        cs.setString(2, nuevaPassword);
        return cs.executeUpdate() > 0;
    }
}


    // Eliminar usuario
   public boolean eliminarUsuario(int idUsuario) throws SQLException {
    String sql = "{CALL SP_EliminarUsuario(?)}";

    try (CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idUsuario);
        return cs.executeUpdate() > 0;
    }
}


    // Mapear ResultSet a Usuario
    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setNombre(rs.getString("nombre"));
        u.setApellido(rs.getString("apellido"));
        u.setCorreo(rs.getString("correo_electronico"));
        u.setPassword(rs.getString("password"));
        u.setTelefono(rs.getString("telefono"));
        u.setDireccion(rs.getString("direccion"));
        u.setTipoDocumento(rs.getString("tipo_documento"));
        u.setNumeroDocumento(rs.getString("numero_documento"));
        u.setGenero(rs.getString("genero"));
        Date fechaSQL = rs.getDate("fecha_nacimiento");
        u.setEstado(rs.getString("estado"));
        u.setInfo(rs.getString("info"));
        u.setIntentoFallo(rs.getInt("intento_fallo"));
        if (fechaSQL != null) {
            u.setFechaNacimiento(fechaSQL.toLocalDate());
        }
        u.setRol(rs.getString("rol"));
        return u;
    }
    
    public void aumentarIntentosFallidos(int idUsuario) throws SQLException {

        String sql = "UPDATE usuarios "
                   + "SET intento_fallo = intento_fallo + 1 "
                   + "WHERE id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            ps.executeUpdate();
        }
    }
    public void reiniciarIntentos(int idUsuario) throws SQLException {

        String sql = "UPDATE usuarios "
                   + "SET intento_fallo = 0 "
                   + "WHERE id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        }
    }
    public void bloquearCuenta(int idUsuario) throws SQLException {

        String sql = "UPDATE usuarios "
                   + "SET estado = 'Bloqueado' "
                   + "WHERE id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.executeUpdate();
        }
    }
    public void actualizarInfo(int idUsuario, String info)
        throws SQLException {

        String sql = "UPDATE usuarios "
                   + "SET info = ? "
                   + "WHERE id_usuario = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, info);
            ps.setInt(2, idUsuario);

            ps.executeUpdate();
        }
    }
    public void actualizarEstadoCuenta(
        int idUsuario,
        String estado,
        String info) throws SQLException {

        String sql =
                "UPDATE usuarios "
              + "SET estado = ?, info = ? "
              + "WHERE id_usuario = ?";

        try (PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, estado);
            ps.setString(2, info);
            ps.setInt(3, idUsuario);

            ps.executeUpdate();
        }
    }
}
