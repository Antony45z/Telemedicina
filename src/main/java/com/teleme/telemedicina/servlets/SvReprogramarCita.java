package com.teleme.telemedicina.servlets;

import dao.CitaDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

import modelo.Cita;

@WebServlet(name = "SvReprogramarCita",
            urlPatterns = {"/SvReprogramarCita"})

public class SvReprogramarCita extends HttpServlet {

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
        int idCita =
            Integer.parseInt(
                request.getParameter("idCita")
            );

        String fecha =
            request.getParameter("fecha");

        String hora =
            request.getParameter("hora");

        String motivo =
            request.getParameter(
                "motivoReprogramacion"
            );
        String realizadoPor =
            (String) request.getSession()
                            .getAttribute("rol");

        try {

            CitaDAO citaDAO =
                new CitaDAO();

            // OBTENER CITA ACTUAL
            Cita cita =
                citaDAO.obtenerPorId(idCita);

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
                    redireccion+separador + "&msg=no_permitido"
                );

                return;
            }

            // GUARDAR FECHA ANTERIOR
            Timestamp fechaAnterior =
                new Timestamp(
                    cita.getFechaCita().getTime()
                );

            // NUEVA FECHA
            String fechaCompleta =
                fecha + " " + hora + ":00";

            Timestamp nuevaFecha =
                Timestamp.valueOf(fechaCompleta);

            // GUARDAR HISTORIAL
            citaDAO.guardarHistorialReprogramacion(
                idCita,
                fechaAnterior,
                nuevaFecha,
                motivo,
                realizadoPor
            );

            // ACTUALIZAR CITA
            citaDAO.reprogramarCita(
                idCita,
                nuevaFecha
            );

            response.sendRedirect(
                redireccion +separador+ "&msg=ok"
            );

        } catch(Exception e){

            e.printStackTrace();

            response.sendRedirect(
                redireccion +separador+ "&msg=error"
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int idMedico =
                Integer.parseInt(
                    request.getParameter(
                        "idMedico"
                    )
                );

            String fecha =
                request.getParameter(
                    "fecha"
                );

            CitaDAO citaDAO =
                new CitaDAO();

            List<String> horas =
                citaDAO.obtenerHorasDisponibles(
                    idMedico,
                    fecha
                );

            response.setContentType(
                "application/json"
            );

            response.setCharacterEncoding(
                "UTF-8"
            );

            PrintWriter out =
                response.getWriter();

            out.print("[");

            for(int i = 0;
                i < horas.size();
                i++){

                out.print(
                    "\"" + horas.get(i) + "\""
                );

                if(i < horas.size() - 1){

                    out.print(",");
                }
            }

            out.print("]");

        } catch(Exception e){

            e.printStackTrace();
        }
    }
}