package com.teleme.telemedicina.servlets;

import dao.Conexion;
import java.io.InputStream;
import java.sql.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/SvFotoPerfil")
public class SvFotoPerfil extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idUsuario") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int idUsuario = (int) session.getAttribute("idUsuario");

        try (Connection con = Conexion.getConexion()) {
            String sql = "SELECT foto_perfil FROM usuarios WHERE id_usuario = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InputStream foto = rs.getBinaryStream("foto_perfil");
                if (foto != null) {
                    response.setContentType("image/jpeg");
                    foto.transferTo(response.getOutputStream());
                } else {
                    response.sendRedirect("img/default-user.png");
                }
            } else {
                response.sendRedirect("img/default-user.png");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("img/default-user.png");
        }
    }
}
