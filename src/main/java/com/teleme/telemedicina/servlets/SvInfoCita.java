    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.teleme.telemedicina.servlets;

import dao.CitaDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import modelo.Cancelacion;
import modelo.Reprogramacion;




   @WebServlet("/SvInfoCita")
public class SvInfoCita extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        int idCita =
            Integer.parseInt(
                request.getParameter("idCita")
            );

        CitaDAO dao = new CitaDAO();

        List<Reprogramacion> reprogramaciones =
            dao.obtenerReprogramaciones(idCita);

        List<Cancelacion> cancelaciones =
            dao.obtenerCancelaciones(idCita);

        response.setContentType(
            "text/html;charset=UTF-8"
        );

        PrintWriter out =
            response.getWriter();

        if(reprogramaciones.isEmpty()
           && cancelaciones.isEmpty()){

            out.println(
                "<div class='alert alert-info text-center'>"
              + "No existe información adicional para esta cita."
              + "</div>"
            );

            return;
        }

        if(!reprogramaciones.isEmpty()){

            out.println(
                "<h5 class='text-warning mb-3'>"
              + "Reprogramaciones"
              + "</h5>"
            );

            for(Reprogramacion r : reprogramaciones){

                out.println(
                    "<div class='card mb-3'>"
                  + "<div class='card-body'>"

                  + "<p><strong>Fecha anterior:</strong> "
                  + r.getFechaAnterior()
                  + "</p>"

                  + "<p><strong>Fecha nueva:</strong> "
                  + r.getFechaNueva()
                  + "</p>"

                  + "<p><strong>Motivo:</strong> "
                  + r.getMotivo()
                  + "</p>"

                  + "<p><strong>Realizado por:</strong> "
                  + r.getRealizadoPor()
                  + "</p>"

                  + "<p class='mb-0'>"
                  + "<strong>Fecha de acción:</strong> "
                  + r.getFechaAccion()
                  + "</p>"

                  + "</div>"
                  + "</div>"
                );
            }
        }

        if(!cancelaciones.isEmpty()){

            out.println(
                "<h5 class='text-danger mt-4 mb-3'>"
              + "Cancelaciones"
              + "</h5>"
            );

            for(Cancelacion c : cancelaciones){

                out.println(
                    "<div class='card mb-3'>"
                  + "<div class='card-body'>"

                  + "<p><strong>Motivo:</strong> "
                  + c.getMotivo()
                  + "</p>"

                  + "<p><strong>Realizado por:</strong> "
                  + c.getRealizadoPor()
                  + "</p>"

                  + "<p class='mb-0'>"
                  + "<strong>Fecha de cancelación:</strong> "
                  + c.getFechaCancelacion()
                  + "</p>"

                  + "</div>"
                  + "</div>"
                );
            }
        }
    }
}
    
