package com.teleme.telemedicina.servlets;

import dao.Conexion;
import dao.UsuarioDAO;
import dao.PacienteDAO;
import dao.MedicoDAO;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;
import java.nio.charset.StandardCharsets;
import modelo.Usuario;

@WebServlet(name = "SvLogin", urlPatterns = {"/SvLogin"})
public class SvLogin extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String contextPath = request.getContextPath();

        String correo = request.getParameter("correo");

        String passwordCifrada =
                request.getParameter("password");
        if(passwordCifrada == null || passwordCifrada.isEmpty()){

            mostrarError(request,response,
            "❌ Contraseña vacía.");

            return;
        }

        String password = "";

        try {
            System.out.println("PASSWORD RECIBIDA:");
            System.out.println(passwordCifrada);
            password = descifrarPassword(passwordCifrada);

        } catch(Exception e){

            mostrarError(request, response,
                    "❌ Error procesando contraseña.");

            return;
        }

        //VALIDAR CAMPOS VACÍOS
        if (correo == null || correo.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            mostrarError(request, response,
                    "❌ Debe llenar todos los campos.");

            return;
        }

        correo = correo.trim();
        password = password.trim();

        //VALIDAR LONGITUD CORREO
        if (correo.length() > 100) {

            mostrarError(request, response,
                    "❌ El correo excede el límite permitido.");

            return;
        }

        //VALIDAR LONGITUD PASSWORD
        if (password.length() > 45) {

            mostrarError(request, response,
                    "❌ La contraseña excede el límite permitido.");

            return;
        }

        //VALIDAR FORMATO DE CORREO
        String regexCorreo =
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";

        if (!correo.matches(regexCorreo)) {

            mostrarError(request, response,
                    "❌ El formato del correo es inválido.");

            return;
        }
        //VALIDAR FORMATO DE CONTRASEÑA
        String regexPassword = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&_]).{8,45}$";

        if (!password.matches(regexPassword)) {
            mostrarError(request, response, 
                "❌ La contraseña no cumple con los requisitos de seguridad (debe incluir mayúscula, minúscula, número y símbolo).");
            return;
        }
        String gRecaptchaResponse =
                request.getParameter("g-recaptcha-response");

        if (gRecaptchaResponse == null
                || gRecaptchaResponse.isEmpty()) {

            mostrarError(request, response,
                    "❌ Debe completar el captcha.");

            return;
        }

        //VALIDAR CAPTCHA
        if (!verificarCaptcha(gRecaptchaResponse)) {

            mostrarError(request, response,
                    "❌ Captcha inválido.");

            return;
        }

        try (Connection con = Conexion.getConexion()) {

            if (con == null) {
                throw new SQLException("No se pudo conectar a la BD.");
            }

            UsuarioDAO usuarioDAO = new UsuarioDAO(con);

            Usuario usuario = usuarioDAO.obtenerPorCorreo(correo);

            //VALIDAR EXISTENCIA
            if (usuario == null) {

                mostrarError(request, response,
                        "❌ Correo o contraseña incorrectos.");

                return;
            }

            //VALIDAR BLOQUEO
            if ("Bloqueado".equalsIgnoreCase(usuario.getEstado())) {

                mostrarError(request, response,
                        "❌ Su cuenta ha sido bloqueada por demasiados intentos fallidos.");

                return;
            }

            //VALIDACIÓN PASSWORD CON BCRYPT
            String passwordIngresada = password.trim();
            String passwordBD = usuario.getPassword().trim();

            boolean loginCorrecto =
                    at.favre.lib.crypto.bcrypt.BCrypt.verifyer()
                    .verify(
                            passwordIngresada.toCharArray(),
                            passwordBD
                    ).verified;

            // =========================================
            // LOGIN CORRECTO
            // =========================================

            if (loginCorrecto) {

                //REINICIAR INTENTOS
                usuarioDAO.reiniciarIntentos(usuario.getIdUsuario());

                //RECARGAR USUARIO ACTUALIZADO
                usuario = usuarioDAO.obtenerPorCorreo(correo);

                //INICIAR SESIÓN
                iniciarSesion(usuario,
                        request,
                        response,
                        contextPath,
                        con);

            } else {

                //AUMENTAR INTENTOS
                usuarioDAO.aumentarIntentosFallidos(
                        usuario.getIdUsuario()
                );

                //RECARGAR USUARIO ACTUALIZADO
                usuario = usuarioDAO.obtenerPorCorreo(correo);

                //BLOQUEAR SI LLEGÓ A 5
                if (usuario.getIntentoFallo() >= 5) {

                    //BLOQUEAR CUENTA
                    usuarioDAO.bloquearCuenta(
                            usuario.getIdUsuario()
                    );

                    //GUARDAR MOTIVO
                    usuarioDAO.actualizarInfo(
                            usuario.getIdUsuario(),
                            "Cuenta bloqueada automáticamente por "
                            + "5 intentos fallidos de inicio de sesión."
                    );

                    mostrarError(request, response,
                            "❌ Cuenta bloqueada por demasiados intentos fallidos.");

                } else {

                    int restantes =
                            5 - usuario.getIntentoFallo();

                    mostrarError(request, response,
                            "❌ Contraseña incorrecta. Intentos restantes: "
                            + restantes);
                }

                return;
            }

        } catch (SQLException e) {

            e.printStackTrace();

            mostrarError(request, response,
                    "❌ Error de conexión a la base de datos.");
        }
    }

    /**
     * Inicia sesión y redirige según el rol
     */
    private void iniciarSesion(Usuario usuario,
                               HttpServletRequest request,
                               HttpServletResponse response,
                               String contextPath,
                               Connection con)
            throws IOException {

        HttpSession sesion = request.getSession();

        sesion.setAttribute("usuario", usuario);

        // NORMALIZAR ROL
        String rol = usuario.getRol()
                            .toUpperCase()
                            .replace("É", "E");

        sesion.setAttribute("rol", rol);

        try {

            switch (rol) {

                case "PACIENTE": {

                    PacienteDAO pacienteDAO = new PacienteDAO(con);

                    int idPaciente =
                            pacienteDAO.obtenerIdPorUsuario(usuario.getIdUsuario());

                    sesion.setAttribute("idPaciente", idPaciente);

                    modelo.Paciente paciente =
                            pacienteDAO.obtenerPorId(idPaciente);

                    sesion.setAttribute("paciente", paciente);

                    response.sendRedirect(
                            contextPath + "/SvPublicacionesPaciente"
                    );

                    break;
                }

                case "MEDICO": {

                    MedicoDAO medicoDAO = new MedicoDAO(con);

                    int idMedico =
                            medicoDAO.obtenerIdPorUsuario(usuario.getIdUsuario());

                    sesion.setAttribute("idMedico", idMedico);

                    modelo.Medico medico =
                            medicoDAO.obtenerPorId(idMedico);

                    sesion.setAttribute("medico", medico);

                    response.sendRedirect(
                            contextPath + "/SvPublicacion"
                    );

                    break;
                }

                case "ADMIN":

                    response.sendRedirect(
                            contextPath + "/DashboardAdmin"
                    );

                    break;

                default:

                    response.sendRedirect(
                            contextPath + "/login.jsp?error=rol"
                    );

                    break;
            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.sendRedirect(
                    contextPath + "/login.jsp?error=db"
            );
        }
    }

    /**
     * Mostrar mensajes de error
     */
    private void mostrarError(HttpServletRequest request,
            HttpServletResponse response,
            String mensaje)
            throws ServletException, IOException {

        request.setAttribute("error", mensaje);

        request.getRequestDispatcher("login.jsp")
                .forward(request, response);
    }

    private boolean verificarCaptcha(String captchaResponse) {

        try {

            String secretKey =
                    "6Lcms-ssAAAAAM-89n1q-9T90BdlOCa_GlNisrFh";

            URL url = new URL(
                "https://www.google.com/recaptcha/api/siteverify"
            );

            HttpURLConnection con =
                    (HttpURLConnection) url.openConnection();

            con.setRequestMethod("POST");

            con.setDoOutput(true);

            con.setRequestProperty(
                    "Content-Type",
                    "application/x-www-form-urlencoded"
            );

            String parametros =
                    "secret=" + secretKey
                    + "&response=" + captchaResponse;

            OutputStream os = con.getOutputStream();

            os.write(parametros.getBytes());

            os.flush();
            os.close();

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream())
            );

            String inputLine;

            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {

                response.append(inputLine);
            }

            in.close();

            String resultado = response.toString();
            return resultado.contains("\"success\": true")
                || resultado.contains("\"success\":true");

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }
    private String descifrarPassword(String passwordCifrada) throws Exception {


        String clave =
                "Telemed2026Clave";


        String ivTexto =
                "1234567890123456";


        SecretKeySpec key =
                new SecretKeySpec(
                        clave.getBytes(StandardCharsets.UTF_8),
                        "AES"
                );


        javax.crypto.spec.IvParameterSpec iv =
                new javax.crypto.spec.IvParameterSpec(
                        ivTexto.getBytes(StandardCharsets.UTF_8)
                );


        Cipher cipher =
                Cipher.getInstance(
                        "AES/CBC/PKCS5Padding"
                );


        cipher.init(
                Cipher.DECRYPT_MODE,
                key,
                iv
        );


        byte[] passwordBytes =
                Base64.getDecoder()
                .decode(passwordCifrada);



        byte[] resultado =
                cipher.doFinal(passwordBytes);



        return new String(
                resultado,
                StandardCharsets.UTF_8
        );
    }
}
