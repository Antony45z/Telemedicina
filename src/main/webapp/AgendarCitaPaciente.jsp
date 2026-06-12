<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="java.util.List"%>
<%@page import="dao.CitaDAO"%>
<%@page session="true"%>

<%
    // Verificar sesión de usuario
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Obtener idMedico
    String idMedicoStr = request.getParameter("idMedico");

    if(idMedicoStr == null || idMedicoStr.isEmpty()){
        idMedicoStr = request.getAttribute("idMedico") != null
                ? request.getAttribute("idMedico").toString()
                : null;
    }

    if(idMedicoStr == null){
        response.sendRedirect("ServicioPaciente.jsp");
        return;
    }

    int idMedico = Integer.parseInt(idMedicoStr);

    // Mensaje del servlet
    String mensaje = (String) request.getAttribute("mensaje");

    // Fecha seleccionada
    String fechaSeleccionada = request.getParameter("fecha");

    // DAO
    CitaDAO citaDAO = new CitaDAO();

    // Lista de horas
    List<String> horas = null;

    if(fechaSeleccionada != null && !fechaSeleccionada.isEmpty()){
        horas = citaDAO.obtenerHorasDisponibles(idMedico, fechaSeleccionada);
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Agendar Cita - TELEMED</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }

        body {
            padding-top: 80px;
            background-color: var(--color-secundario);
        }

        .navbar-brand {
            font-weight: bold;
            color: var(--color-principal) !important;
        }

        .nav-link.active {
            color: var(--color-principal) !important;
            font-weight: bold;
        }

        .btn-primary {
            background-color: var(--color-principal);
            border: none;
        }

        .btn-primary:hover {
            background-color: #0ab391;
        }

        .card-title {
            color: var(--color-principal);
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm"
     style="border-bottom: 4px solid var(--color-principal);">

    <div class="container-fluid">

        <a class="navbar-brand" href="#">TELEMED</a>

        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent">

            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <li class="nav-item">
                    <a class="nav-link" href="SvPublicacion">Inicio</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="SvHistorial?tipo=citas">Mis Citas</a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="SvHistorial?tipo=diagnosticos">
                        Mis Diagnósticos
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link active" href="ServicioPaciente.jsp">
                        Servicios
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="VideoConsultaPaciente.jsp">
                        VideoConsulta
                    </a>
                </li>

            </ul>

            <div class="d-flex align-items-center">

                <div class="rounded-circle d-flex align-items-center justify-content-center me-2"
                     style="width:40px;
                            height:40px;
                            background-color: var(--color-principal);
                            color:white;
                            font-weight:bold;
                            font-size:18px;">

                    <%= usuario.getNombre().substring(0,1).toUpperCase() %>

                </div>

                <span>
                    <%= usuario.getNombre() %>
                    <%= usuario.getApellido() %>
                </span>

            </div>

        </div>
    </div>
</nav>

<!-- Mensajes -->
<% if(mensaje != null) { %>

<div class="container mt-4">

    <div class="alert <%= mensaje.startsWith("✅")
            ? "alert-success"
            : "alert-danger" %> text-center">

        <%= mensaje %>

    </div>

</div>

<% } %>

<!-- Formulario -->
<div class="container mt-4">

    <div class="card shadow-sm p-4">

        <h3 class="card-title mb-4">
            Agendar Cita Médica
        </h3>

        <form action="SvRegistrarCita" method="post">

            <input type="hidden" name="idMedico" value="<%= idMedico %>">

            <!-- Paciente -->
            <div class="mb-3">

                <label for="paciente" class="form-label">
                    Paciente
                </label>

                <input type="text"
                       class="form-control"
                       id="paciente"
                       value="<%= usuario.getNombre() + " " + usuario.getApellido() %>"
                       readonly>

            </div>

            <!-- Fecha -->
            <div class="mb-3">

                <label for="fecha" class="form-label">
                    Fecha
                </label>

                <input type="date"
                       class="form-control"
                       id="fecha"
                       name="fecha"
                       value="<%= fechaSeleccionada != null ? fechaSeleccionada : "" %>"
                       onchange="this.form.submit()"
                       required>

            </div>

            <!-- Hora -->
            <div class="mb-3">

                <label for="hora" class="form-label">
                    Hora de la cita
                </label>

                <select class="form-select"
                        id="hora"
                        name="hora"
                        required>

                    <%
                        if(fechaSeleccionada == null || fechaSeleccionada.isEmpty()){
                    %>

                        <option disabled selected>
                            Seleccione primero una fecha
                        </option>

                    <%
                        } else if(horas != null && !horas.isEmpty()) {

                    %>

                        <option value="">
                            Seleccione una hora
                        </option>

                    <%
                            for(String h : horas){
                    %>

                        <option value="<%= h %>">
                            <%= h %>
                        </option>

                    <%
                            }
                        } else {
                    %>

                        <option disabled selected>
                            No hay horarios disponibles
                        </option>

                    <%
                        }
                    %>

                </select>

            </div>

            <!-- Motivo -->
            <div class="mb-3">

                <label for="motivo" class="form-label">
                    Motivo
                </label>

                <textarea class="form-control"
                          id="motivo"
                          name="motivo"
                          rows="3"
                          required></textarea>

            </div>

            <!-- Botón -->
            <button type="submit" class="btn btn-primary w-100">
                Agendar Cita
            </button>

        </form>

    </div>
</div>

</body>
</html>