package dao;

import java.sql.*;
import java.util.*;
import modelo.Cita;
import java.util.Date;
import modelo.Cancelacion;
import modelo.Reprogramacion;
public class CitaDAO {

    //  AGENDAR CITA
    public boolean agendarCita(Cita cita) {
    String sql = "{CALL SP_AgendarCita(?, ?, ?, ?, ?, ?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, cita.getIdPaciente());
        cs.setInt(2, cita.getIdMedico());
        cs.setTimestamp(3, new Timestamp(cita.getFechaCita().getTime()));
        cs.setString(4, cita.getMotivo());
        cs.setString(5, cita.getEstado());
        cs.setString(6, cita.getTicket());

        return cs.executeUpdate() > 0;

    } catch (SQLException e) {
        System.out.println("Error al agendar la cita: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}


   // LISTAR CITAS DE UN PACIENTE
public List<Cita> listarCitasPorPaciente(int idPaciente) {
    List<Cita> citas = new ArrayList<>();

    String sql = "SELECT c.*, " +
                 "u.nombre AS nombre_medico, u.apellido AS apellido_medico, " +
                 "m.especialidad, " +
                 "d.descripcion AS diag_descripcion, " +
                 "d.receta AS diag_receta " +
                 "FROM citas c " +
                 "JOIN medicos m ON c.id_medico = m.id_medico " +
                 "JOIN usuarios u ON m.id_usuario = u.id_usuario " +
                 "LEFT JOIN diagnosticos d ON c.id_cita = d.id_cita " +
                 "WHERE c.id_paciente = ? " +
                 "ORDER BY c.fecha_cita DESC";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idPaciente);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdMedico(rs.getInt("id_medico"));
                cita.setFechaCita(rs.getTimestamp("fecha_cita"));
                cita.setMotivo(rs.getString("motivo"));
                cita.setEstado(rs.getString("estado"));
                cita.setTicket(rs.getString("ticket"));

                cita.setNombreMedico(
                    rs.getString("nombre_medico") + " " + rs.getString("apellido_medico")
                );

                cita.setEspecialidadMedico(rs.getString("especialidad"));

                // 🔥 Nuevo (diagnóstico)
                cita.setDescripcionDiagnostico(rs.getString("diag_descripcion"));
                cita.setRecetaDiagnostico(rs.getString("diag_receta"));

                citas.add(cita);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar citas del paciente: " + e.getMessage());
        e.printStackTrace();
    }

    return citas;
}




    //  LISTAR CITAS DE UN MÉDICO
    public List<Cita> listarCitasPorMedico(int idMedico) {
    List<Cita> citas = new ArrayList<>();
    String sql = "{CALL SP_ListarCitasPorMedico(?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, idMedico);

        try (ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Cita cita = new Cita();
                cita.setIdCita(rs.getInt("id_cita"));
                cita.setIdPaciente(rs.getInt("id_paciente"));
                cita.setIdMedico(rs.getInt("id_medico"));
                cita.setFechaCita(rs.getTimestamp("fecha_cita"));
                cita.setMotivo(rs.getString("motivo"));
                cita.setEstado(rs.getString("estado"));
                cita.setTicket(rs.getString("ticket"));
                citas.add(cita);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar citas del médico: " + e.getMessage());
        e.printStackTrace();
    }

    return citas;
}


    //  LISTAR CITAS PENDIENTES (CON NOMBRE DEL PACIENTE)
    public List<Map<String, Object>> listarPendientesPorMedico(int idMedico) {
    List<Map<String, Object>> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarPendientesPorMedico(?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, idMedico);

        try (ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> cita = new HashMap<>();
                cita.put("id_cita", rs.getInt("id_cita"));
                cita.put("id_paciente", rs.getInt("id_paciente"));
                cita.put("ticket", rs.getString("ticket"));
                cita.put("fecha_cita", rs.getTimestamp("fecha_cita"));
                cita.put("motivo", rs.getString("motivo"));
                cita.put("estado", rs.getString("estado"));
                cita.put("nombre_paciente", rs.getString("nombre_paciente"));
                cita.put("apellido_paciente", rs.getString("apellido_paciente"));
                lista.add(cita);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar citas pendientes: " + e.getMessage());
        e.printStackTrace();
    }

    return lista;
}

    //  LISTAR CITAS COMPLETADAS DE UN MÉDICO CON DIAGNÓSTICO (si existe)
public List<Map<String, Object>> listarCompletadasConDiagnostico(int idMedico) {
    List<Map<String, Object>> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarCompletadasConDiagnostico(?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, idMedico);

        try (ResultSet rs = cs.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> cita = new HashMap<>();
                cita.put("id_cita", rs.getInt("id_cita"));
                cita.put("ticket", rs.getString("ticket"));
                cita.put("fecha_cita", rs.getTimestamp("fecha_cita"));
                cita.put("motivo", rs.getString("motivo"));
                cita.put("estado", rs.getString("estado"));
                cita.put("nombre_paciente", rs.getString("nombre_paciente"));
                cita.put("apellido_paciente", rs.getString("apellido_paciente"));
                cita.put("diagnostico", rs.getString("diagnostico"));
                 
                cita.put("receta", rs.getString("receta"));
                cita.put("tratamiento",rs.getString("tratamiento")); //nuevo
                lista.add(cita);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar citas completadas: " + e.getMessage());
        e.printStackTrace();
    }

    return lista;
}

//  LISTAR TODAS LAS CITAS CON NOMBRES DE MÉDICO Y PACIENTE
public List<Map<String, Object>> listarCitasDetalladas() {
    List<Map<String, Object>> lista = new ArrayList<>();
    String sql = "{CALL SP_ListarCitasDetalladas()}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql);
         ResultSet rs = cs.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> cita = new HashMap<>();
            cita.put("id_cita", rs.getInt("id_cita"));
            cita.put("ticket", rs.getString("ticket"));
            cita.put("fecha_cita", rs.getTimestamp("fecha_cita"));
            cita.put("motivo", rs.getString("motivo"));
            cita.put("estado", rs.getString("estado"));
            cita.put("nombre_paciente", rs.getString("nombre_paciente"));
            cita.put("nombre_medico", rs.getString("nombre_medico"));
            lista.add(cita);
        }

    } catch (SQLException e) {
        System.out.println("Error al listar citas detalladas: " + e.getMessage());
        e.printStackTrace();
    }

    return lista;
}


//  OBTENER CITA DETALLADA POR ID (para editar)
public Map<String, Object> obtenerCitaDetallada(int idCita) {
    Map<String, Object> cita = null;
    String sql = "{CALL SP_ObtenerCitaDetallada(?)}";

    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {

        cs.setInt(1, idCita);
        try (ResultSet rs = cs.executeQuery()) {
            if (rs.next()) {
                cita = new HashMap<>();
                cita.put("id_cita", rs.getInt("id_cita"));
                cita.put("ticket", rs.getString("ticket"));
                cita.put("fecha_cita", rs.getTimestamp("fecha_cita"));
                cita.put("motivo", rs.getString("motivo"));
                cita.put("estado", rs.getString("estado"));
                cita.put("id_paciente", rs.getInt("id_paciente"));
                cita.put("id_medico", rs.getInt("id_medico"));
                cita.put("nombre_paciente", rs.getString("nombre_paciente"));
                cita.put("nombre_medico", rs.getString("nombre_medico"));
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al obtener cita detallada: " + e.getMessage());
        e.printStackTrace();
    }

    return cita;
}


//  ELIMINAR CITA
public boolean eliminarCita(int idCita) {
    String sql = "{CALL SP_EliminarCita(?)}";
    try (Connection con = Conexion.getConexion();
         CallableStatement cs = con.prepareCall(sql)) {
        cs.setInt(1, idCita);
        return cs.executeUpdate() > 0;
    } catch (SQLException e) {
        System.out.println("Error al eliminar la cita: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

// En CitaDAO.java
// 🚨 MÉTODO PARA REPORTES DE PACIENTES 🚨
public List<Map<String, Object>> listarCitasConDiagnosticoPorPaciente(int idPaciente) {
    List<Map<String, Object>> lista = new ArrayList<>();
    // Asegúrate de tener un SP o una consulta SQL que obtenga Citas, Pacientes y Diagnósticos
    // Aquí usamos una consulta SQL directa como ejemplo, si no tienes un SP específico:
    String sql = "SELECT c.id_paciente,c.id_cita, c.fecha_cita, c.motivo, c.estado, c.ticket, "
               + "u_pac.nombre AS nombre_paciente, u_pac.apellido AS apellido_paciente, "
               + "d.descripcion AS diagnostico, d.receta, d.tratamiento " //nuevo
               + "FROM citas c "
               + "JOIN pacientes p ON c.id_paciente = p.id_paciente "
               + "JOIN usuarios u_pac ON p.id_usuario = u_pac.id_usuario "
               + "LEFT JOIN diagnosticos d ON c.id_cita = d.id_cita "
               + "WHERE c.id_paciente = ? AND c.estado = 'Completada' " // Filtrar por completadas
               + "ORDER BY c.fecha_cita DESC";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idPaciente);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> cita = new HashMap<>();
                cita.put("id_cita", rs.getInt("id_cita"));
                cita.put("id_paciente", rs.getInt("id_paciente")); 
                cita.put("fecha_cita", rs.getTimestamp("fecha_cita"));
                cita.put("motivo", rs.getString("motivo"));
                cita.put("estado", rs.getString("estado"));
                cita.put("nombre_paciente", rs.getString("nombre_paciente"));
                cita.put("apellido_paciente", rs.getString("apellido_paciente"));
                cita.put("ticket", rs.getString("ticket"));
                cita.put("diagnostico", rs.getString("diagnostico"));
                cita.put("receta", rs.getString("receta"));
                cita.put("tratamiento",rs.getString("tratamiento"));//nuevo
                lista.add(cita);
            }
        }

    } catch (SQLException e) {
        System.out.println("Error al listar historial del paciente: " + e.getMessage());
        e.printStackTrace();
    }

    return lista;
}
public Map<Integer, Integer> obtenerCitasPorMes2025() {
    Map<Integer, Integer> data = new HashMap<>();
    
    String sql = "SELECT MONTH(fecha_cita) AS mes, COUNT(*) AS total " +
                 "FROM citas WHERE YEAR(fecha_cita)=2026 " +
                 "GROUP BY MONTH(fecha_cita) ORDER BY mes";

    try (Connection conn = Conexion.getConexion();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            data.put(rs.getInt("mes"), rs.getInt("total"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return data;
}
private static final List<String> HORARIOS_BASE = Arrays.asList(
        "08:00","08:30","09:00","09:30",
        "10:00","10:30","11:00","11:30",
        "13:00","13:30","14:00","14:30",
        "15:00","15:30","16:00","16:30",
        "17:00","17:30","18:00","18:30",
        "19:00","19:30","20:00"
    );

    // 🔥 OBTENER HORAS DISPONIBLES
    public List<String> obtenerHorasDisponibles(int idMedico, String fecha) {

        List<String> disponibles = new ArrayList<>(HORARIOS_BASE);
        List<String> ocupadas = new ArrayList<>();

        String sql = "SELECT DATE_FORMAT(fecha_cita, '%H:%i') AS hora "
                   + "FROM citas "
                   + "WHERE id_medico = ? "
                   + "AND DATE(fecha_cita) = ? "
                   + "AND estado != 'Cancelada'";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idMedico);
            ps.setString(2, fecha);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ocupadas.add(rs.getString("hora"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        disponibles.removeAll(ocupadas);

        return disponibles;
    }
    public boolean existeCitaMedicoEnHora(int idMedico, Date fechaCita) {

        String sql = "SELECT COUNT(*) FROM citas "
                   + "WHERE id_medico = ? "
                   + "AND fecha_cita = ? "
                   + "AND estado != 'Cancelada'";

        try (Connection conn = Conexion.getConexion();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, idMedico);
            ps.setTimestamp(2, new Timestamp(fechaCita.getTime()));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public void reprogramarCita(
        int idCita,
        Timestamp nuevaFecha) {

        String sql =
            "UPDATE citas " +
            "SET fecha_Cita = ? " +
            "WHERE id_cita = ?";

        try {

            Connection con = Conexion.getConexion();

            PreparedStatement ps =
                con.prepareStatement(sql);

            ps.setTimestamp(1, nuevaFecha);

            ps.setInt(2, idCita);

            ps.executeUpdate();

        } catch (SQLException e) {

            e.printStackTrace();
        }
    }
    public Cita obtenerPorId(int idCita) {

    Cita cita = null;

    String sql =
        "SELECT * FROM citas " +
        "WHERE id_cita = ?";

    try (Connection con = Conexion.getConexion();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idCita);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            cita = new Cita();

            cita.setIdCita(
                rs.getInt("id_cita")
            );

            cita.setTicket(
                rs.getString("ticket")
            );

            cita.setIdPaciente(
                rs.getInt("id_paciente")
            );

            cita.setIdMedico(
                rs.getInt("id_medico")
            );

            cita.setFechaCita(
                rs.getTimestamp("fecha_cita")
            );

            cita.setMotivo(
                rs.getString("motivo")
            );

            cita.setEstado(
                rs.getString("estado")
            );

            cita.setFechaRegistro(
                rs.getTimestamp("fecha_registro")
            );

            cita.setHoraFin(
                rs.getTimestamp("hora_fin")
            );
        }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return cita;
    }
    public boolean guardarHistorialReprogramacion(
        int idCita,
        Timestamp fechaAnterior,
        Timestamp fechaNueva,
        String motivo, String realizadoPor){

        String sql =
            "INSERT INTO historial_reprogramacion_cita "
          + "(id_cita, "
          + "fecha_anterior, "
          + "fecha_nueva, "
          + "motivo_reprogramacion, realizado_por) "
          + "VALUES (?, ?, ?, ?,?)";

        try(
            Connection conn =
                Conexion.getConexion();

            PreparedStatement ps =
                conn.prepareStatement(sql)
        ){

            ps.setInt(
                1,
                idCita
            );

            ps.setTimestamp(
                2,
                fechaAnterior
            );

            ps.setTimestamp(
                3,
                fechaNueva
            );

            ps.setString(
                4,
                motivo
            );
            ps.setString(
                5,
                realizadoPor
            );
            return ps.executeUpdate() > 0;

        } catch(Exception e){

            e.printStackTrace();
        }

        return false;
    }
    public boolean cancelarCita(int idCita) {

        String sql =
            "UPDATE citas " +
            "SET estado = 'Cancelada' " +
            "WHERE id_cita = ?";

        try (
            Connection conn = Conexion.getConexion();
            PreparedStatement ps =
                conn.prepareStatement(sql)
        ){

            ps.setInt(1, idCita);

            return ps.executeUpdate() > 0;

        } catch(Exception e){

            e.printStackTrace();
        }

        return false;
    }
    public boolean guardarHistorialCancelacion(
        int idCita,
        String motivo,
        String realizadoPor){

        String sql =
            "INSERT INTO historial_cancelacion_cita "
          + "(id_cita, "
          + "motivo_cancelacion, "
          + "realizado_por) "
          + "VALUES (?, ?, ?)";

        try(

            Connection conn =
                Conexion.getConexion();

            PreparedStatement ps =
                conn.prepareStatement(sql)

        ){

            ps.setInt(
                1,
                idCita
            );

            ps.setString(
                2,
                motivo
            );

            ps.setString(
                3,
                realizadoPor
            );

            return ps.executeUpdate() > 0;

        } catch(Exception e){

            e.printStackTrace();
        }

        return false;
    }
    public List<Reprogramacion> obtenerReprogramaciones(int idCita){

        List<Reprogramacion> lista =
            new ArrayList<>();

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{

            cn = Conexion.getConexion();

            String sql =
                "SELECT fecha_anterior, "
              + "fecha_nueva, "
              + "motivo_reprogramacion, "
              + "realizado_por, "
              + "fecha_reprogramacion "
              + "FROM historial_reprogramacion_cita "
              + "WHERE id_cita = ? "
              + "ORDER BY fecha_reprogramacion DESC";

            ps = cn.prepareStatement(sql);

            ps.setInt(1, idCita);

            rs = ps.executeQuery();

            while(rs.next()){

                Reprogramacion r =
                    new Reprogramacion();

                r.setFechaAnterior(
                    rs.getTimestamp("fecha_anterior")
                );

                r.setFechaNueva(
                    rs.getTimestamp("fecha_nueva")
                );

                r.setMotivo(
                    rs.getString("motivo_reprogramacion")
                );

                r.setRealizadoPor(
                    rs.getString("realizado_por")
                );

                r.setFechaAccion(
                    rs.getTimestamp("fecha_reprogramacion")
                );

                lista.add(r);
            }

        }catch(Exception e){

            e.printStackTrace();

        }finally{

            try{
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(cn != null) cn.close();
            }catch(Exception e){}
        }

        return lista;
    }
    public List<Cancelacion> obtenerCancelaciones(int idCita){

        List<Cancelacion> lista =
            new ArrayList<>();

        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{

            cn = Conexion.getConexion();

            String sql =
                "SELECT motivo_cancelacion, "
              + "realizado_por, "
              + "fecha_cancelacion "
              + "FROM historial_cancelacion_cita "
              + "WHERE id_cita = ? "
              + "ORDER BY fecha_cancelacion DESC";

            ps = cn.prepareStatement(sql);

            ps.setInt(1, idCita);

            rs = ps.executeQuery();

            while(rs.next()){

                Cancelacion c =
                    new Cancelacion();

                c.setMotivo(
                    rs.getString("motivo_cancelacion")
                );

                c.setRealizadoPor(
                    rs.getString("realizado_por")
                );

                c.setFechaCancelacion(
                    rs.getTimestamp("fecha_cancelacion")
                );

                lista.add(c);
            }

        }catch(Exception e){

            e.printStackTrace();

        }finally{

            try{
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(cn != null) cn.close();
            }catch(Exception e){}
        }

        return lista;
    }
}
