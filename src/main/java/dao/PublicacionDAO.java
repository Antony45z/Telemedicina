package dao;

import modelo.Publicacion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.CallableStatement;
import java.util.ArrayList;
import java.util.List;

public class PublicacionDAO {

    private final Connection con;

    public PublicacionDAO(Connection con) {
        this.con = con;
    }

    // ============================================================
    // INSERTAR PUBLICACION
    // ============================================================
    public boolean insertarPublicacion(Publicacion p) {
        String sql = "{CALL SP_InsertarPublicacion(?, ?, ?, ?)}";

        try (CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, p.getIdMedico());
            cs.setInt(2, p.getIdCategoria());
            cs.setString(3, p.getTitulo());
            cs.setString(4, p.getContenido());

            return cs.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al insertar publicación: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // ACTUALIZAR PUBLICACION
    // ============================================================
    public boolean actualizarPublicacion(Publicacion p) {
       String sql = "UPDATE Publicaciones "
           + "SET id_medico = ?, id_categoria = ?, titulo = ?, contenido = ? "
           + "WHERE id_publicacion = ?";


        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getIdMedico());
            ps.setInt(2, p.getIdCategoria());
            ps.setString(3, p.getTitulo());
            ps.setString(4, p.getContenido());
            ps.setInt(5, p.getIdPublicacion());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al actualizar publicación: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // ELIMINAR PUBLICACION
    // ============================================================
    public boolean eliminarPublicacion(int idPublicacion) {
        String sql = "DELETE FROM Publicaciones WHERE id_publicacion = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPublicacion);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error al eliminar publicación: " + e.getMessage());
            return false;
        }
    }

    // ============================================================
    // OBTENER PUBLICACION POR ID
    // ============================================================
    public Publicacion obtenerPorId(int idPublicacion) {
        String sql = "{CALL SP_ObtenerPublicacionPorId(?)}";
        Publicacion pub = null;

        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idPublicacion);

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    pub = new Publicacion();
                    pub.setIdPublicacion(rs.getInt("id_publicacion"));
                    pub.setIdMedico(rs.getInt("id_medico"));
                    pub.setIdCategoria(rs.getInt("id_categoria"));
                    pub.setTitulo(rs.getString("titulo"));
                    pub.setContenido(rs.getString("contenido"));
                    pub.setFechaPublicacion(rs.getTimestamp("fecha_publicacion"));

                    // Si tus SP devuelven estos campos
                    pub.setNombreCategoria(rs.getString("nombre_categoria"));
                    pub.setNombreMedico(
                        rs.getString("nombre_medico") + " " + rs.getString("apellido_medico")
                    );
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener publicación por ID: " + e.getMessage());
        }

        return pub;
    }

    // ============================================================
    // LISTAR TODAS
    // ============================================================
    public List<Publicacion> obtenerTodas() {

        String sql = "{CALL SP_ObtenerTodasPublicaciones()}";
        List<Publicacion> lista = new ArrayList<>();

        try (CallableStatement cs = con.prepareCall(sql);
             ResultSet rs = cs.executeQuery()) {

            while (rs.next()) {
                Publicacion pub = new Publicacion();
                pub.setIdPublicacion(rs.getInt("id_publicacion"));
                pub.setIdMedico(rs.getInt("id_medico"));
                pub.setIdCategoria(rs.getInt("id_categoria"));
                pub.setTitulo(rs.getString("titulo"));
                pub.setContenido(rs.getString("contenido"));
                pub.setFechaPublicacion(rs.getTimestamp("fecha_publicacion"));

                pub.setNombreCategoria(rs.getString("nombre_categoria"));
                pub.setNombreMedico(
                    rs.getString("nombre_medico") + " " + rs.getString("apellido_medico")
                );
                pub.setFotoMedico(rs.getBytes("foto_perfil"));
                lista.add(pub);
            }

        } catch (SQLException e) {
            System.out.println("Error al obtener todas las publicaciones: " + e.getMessage());
        }

        return lista;
    }

    // ============================================================
    // LISTAR POR MEDICO
    // ============================================================
    public List<Publicacion> listarPorMedico(int idMedico) {
        String sql = "{CALL SP_ListarPublicacionesPorMedico(?)}";
        List<Publicacion> lista = new ArrayList<>();

        try (CallableStatement cs = con.prepareCall(sql)) {
            cs.setInt(1, idMedico);

            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    Publicacion pub = new Publicacion();
                    pub.setIdPublicacion(rs.getInt("id_publicacion"));
                    pub.setIdMedico(idMedico);
                    pub.setIdCategoria(rs.getInt("id_categoria"));
                    pub.setTitulo(rs.getString("titulo"));
                    pub.setContenido(rs.getString("contenido"));
                    pub.setFechaPublicacion(rs.getTimestamp("fecha_publicacion"));
                    pub.setNombreCategoria(rs.getString("nombre_categoria"));

                    lista.add(pub);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error al listar publicaciones por médico: " + e.getMessage());
        }

        return lista;
    }
}
