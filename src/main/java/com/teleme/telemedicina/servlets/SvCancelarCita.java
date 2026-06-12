package com.teleme.telemedicina.servlets;

import dao.CitaDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

import modelo.Cita;

@WebServlet(name = "SvCancelarCita",
            urlPatterns = {"/SvCancelarCita"})

public class SvCancelarCita extends HttpServlet {

    @Override
    protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {
        String rol =
                (String) request.getSession()
                                .getAttribute("rol");
        
            String redireccion;
            
            if("MEDICO".equalsIgnoreCase(rol)){

                redireccion = "SvCitasPendientesMedico";

            } else {

                redireccion = "SvHistorial?tipo=citas";
            }
            String separador =
            redireccion.contains("?")
            ? "&"
            : "?";
        try {
            
            int idCita =
                Integer.parseInt(
                    request.getParameter("idCita")
                );

            String motivo =
                request.getParameter("motivo");

            String realizadoPor =
                (String) request.getSession()
                                .getAttribute("rol");

            CitaDAO citaDAO =
                new CitaDAO();

            // OBTENER CITA
            Cita cita =
                citaDAO.obtenerPorId(idCita);

            if(cita == null){

                response.sendRedirect(
                    redireccion +separador+ "&msg=no_existe"
                );

                return;
            }

            // VALIDAR 24 HORAS
            long ahora =
                System.currentTimeMillis();

            long fechaCita =
                cita.getFechaCita().getTime();

            boolean puedeModificar =
                   (fechaCita - ahora) >
                   (24L * 60 * 60 * 1000)
                ||
                   (ahora - fechaCita) >
                   (30L * 60 * 1000);

            if(!puedeModificar){

                response.sendRedirect(
                    redireccion +separador+ "&msg=no_permitido"
                );

                return;
            }

            // VALIDAR ESTADO
            if(!"Pendiente".equalsIgnoreCase(
                    cita.getEstado())){

                response.sendRedirect(
                    redireccion +separador+ "&msg=estado_invalido"
                );

                return;
            }

            // GUARDAR HISTORIAL
            citaDAO.guardarHistorialCancelacion(
                idCita,
                motivo,
                realizadoPor
            );

            // CANCELAR CITA
            boolean exito =
                citaDAO.cancelarCita(idCita);

            if(exito){

                response.sendRedirect(
                    redireccion+separador + "&msg=cancelada"
                );

            } else {

                response.sendRedirect(
                    redireccion+separador + "&msg=error"
                );
            }

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                redireccion+separador + "&msg=error"
            );
        }
    }
}