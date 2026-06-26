package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    private static final String URL = "jdbc:mysql://roundhouse.proxy.rlwy.net:31989/telemedicina?useSSL=false&useTimezone=true&serverTimezone=America/Lima&allowPublicKeyRetrieval=true&connectionCollation=utf8mb4_general_ci";
    private static final String USER = "consultas";
    private static final String PASSWORD = "mBMsw6aAy[Af]q*u";

    public static Connection getConexion() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Asegúrate de tener mysql-connector-java
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Driver de MySQL no encontrado");
            e.printStackTrace();
            return null;
        } catch (SQLException e) {
            System.out.println("Error al conectar con la base de datos");
            e.printStackTrace();
            throw e;
        }
    }

    static Connection getConnection() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
