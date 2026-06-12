    package com.teleme.telemedicina.servlets;
    import java.sql.Timestamp;
    import java.text.SimpleDateFormat;

    import com.itextpdf.text.*;
    import com.itextpdf.text.pdf.*;
    import java.io.IOException;
    import java.util.List;
    import java.util.Map;
    import java.util.Date;
    import jakarta.servlet.ServletException;
    import jakarta.servlet.annotation.WebServlet;
    import jakarta.servlet.http.HttpServlet;
    import jakarta.servlet.http.HttpServletRequest;
    import jakarta.servlet.http.HttpServletResponse;
    import jakarta.servlet.http.HttpSession;

    import modelo.Medico;
    import dao.CitaDAO;

    @WebServlet(name = "SvReporteCitas", urlPatterns = {"/SvReporteCitas"})
    public class SvReporteCitas extends HttpServlet {

        protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {

            // 1. Obtener sesión y médico
            HttpSession session = request.getSession();
            Medico medico = (Medico) session.getAttribute("medico");

            if (medico == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            String tipo = request.getParameter("tipo");
            CitaDAO dao = new CitaDAO();
            List<Map<String, Object>> listaCitas = null;

            // Parámetros para el PDF
            String tituloReporte;
            String nombreArchivo;

            // --- 🚨 LÓGICA CENTRAL PARA MANEJAR TIPOS DE REPORTE 🚨 ---

            if ("pdf_paciente".equals(tipo)) {
                // Se solicita el historial de un paciente específico desde la tarjeta de cita.
                String idPacienteStr = request.getParameter("id_paciente");
                int idPaciente;

                try {
                    idPaciente = Integer.parseInt(idPacienteStr);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de paciente inválido.");
                    return;
                }

                // Llamada al método DAO que filtra por paciente
                listaCitas = dao.listarCitasConDiagnosticoPorPaciente(idPaciente);

                // Determinar título y nombre del archivo
                String nombrePaciente = "Historial Completo";
                if (listaCitas != null && !listaCitas.isEmpty()) {
                    nombrePaciente = (String) listaCitas.get(0).get("nombre_paciente") + "_" + (String) listaCitas.get(0).get("apellido_paciente");
                }

                tituloReporte = "HISTORIAL CLÍNICO - " + nombrePaciente.replace("_", " ");
                nombreArchivo = "Historial_" + nombrePaciente + "_" + idPaciente + ".pdf";

                // Generar PDF con los parámetros específicos
                generarPDF(response, listaCitas, medico, tituloReporte, nombreArchivo);

            } else if ("pdf".equals(tipo)) {
                // Se solicita el reporte general de todas las citas completadas del médico (Comportamiento original).
                listaCitas = dao.listarCompletadasConDiagnostico(medico.getIdMedico());

                tituloReporte = "REPORTE GENERAL DE CITAS COMPLETADAS";
                nombreArchivo = "Reporte_General_Dr_" + medico.getIdMedico() + ".pdf";

                generarPDF(response, listaCitas, medico, tituloReporte, nombreArchivo);

            } else if ("excel".equals(tipo)) {
                // Aquí iría la lógica de Excel si la necesitas
                response.getWriter().println("Funcionalidad Excel pendiente de implementar con Apache POI");
            } else {
                 response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tipo de reporte no especificado o inválido.");
            }
        }

        // --- 🚨 MÉTODO GENERADOR DE PDF ACTUALIZADO 🚨 ---
        // Ahora recibe el título y el nombre del archivo de forma dinámica.
        private void generarPDF(HttpServletResponse response, 
                                List<Map<String, Object>> lista, 
                                Medico medico,
                                String tituloReporte,
                                String nombreArchivo) throws IOException {

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=" + nombreArchivo);

            try {
                Document document = new Document();
                PdfWriter.getInstance(document, response.getOutputStream());
                document.open();

                // Título
                Font fontTitulo = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
                Paragraph titulo = new Paragraph(tituloReporte, fontTitulo);
                titulo.setAlignment(Element.ALIGN_CENTER);
                document.add(titulo);

                document.add(new Paragraph(" "));
                document.add(new Paragraph("Médico Generador: Dr. " + medico.getNombre() + " " + medico.getApellido()));
                document.add(new Paragraph("Fecha de Generación: " + new Date().toString()));
                document.add(new Paragraph(" ")); 

                // Tabla
                PdfPTable table = new PdfPTable(7); // 

                table.setWidthPercentage(100);
                table.setSpacingBefore(10f);

                // Encabezados
                addHeader(table, "Ticket");
                addHeader(table, "Paciente");
                addHeader(table, "Fecha");
                addHeader(table, "Motivo");
                addHeader(table, "Diagnóstico");
                addHeader(table, "Receta");
                addHeader(table, "Tratamiento");//nuevo


                // Datos
                if (lista != null) {
                    for (Map<String, Object> fila : lista) {
                        String ticket = (fila.get("ticket") != null) ? fila.get("ticket").toString() : "—";
                        String motivo = (fila.get("motivo") != null) ? fila.get("motivo").toString() : "—";
                        String nombre = fila.get("nombre_paciente") + " " + fila.get("apellido_paciente");
                        String diagnostico = (fila.get("diagnostico") != null) ? fila.get("diagnostico").toString() : "Sin diagnóstico";
                        String receta = (fila.get("receta") != null) ? fila.get("receta").toString() : "—";
                        Timestamp fechaObj = (Timestamp) fila.get("fecha_cita");
                        String fecha = (fechaObj != null) ? new SimpleDateFormat("yyyy-MM-dd HH:mm").format(fechaObj) : "—";
                        String tratamiento= (fila.get("tratamiento")!=null) ?fila.get("tratamiento").toString():"Sin tratamiento";//nuevo

                       table.addCell(ticket);
                        table.addCell(nombre);
                        table.addCell(fecha);
                        table.addCell(motivo);
                        table.addCell(diagnostico);
                        table.addCell(receta);
                        table.addCell(tratamiento);//nuevo

                    }
                }

                document.add(table);
                document.close();

            } catch (DocumentException e) {
                System.err.println("Error al generar PDF: " + e.getMessage());
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error interno al generar el PDF: " + e.getMessage());
            }
        }

        private void addHeader(PdfPTable table, String text) {
            PdfPCell cell = new PdfPCell(new Phrase(text, FontFactory.getFont(FontFactory.HELVETICA_BOLD)));
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            processRequest(request, response);
        }
    }