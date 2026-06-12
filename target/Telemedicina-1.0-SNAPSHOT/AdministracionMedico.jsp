<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="java.util.List"%>
<%@page import="modelo.Medico"%>
<%@ page session="true" %>
<%
    String rol = (String) session.getAttribute("rol");

    // NO AUTENTICADO
    if(rol == null){

        response.sendRedirect("login.jsp");
        return;
    }

    // AUTENTICADO PERO NO ES ADMIN
    if(!rol.equals("ADMIN")){

        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }
%>
<%
    String mensaje = request.getParameter("mensaje");

    String texto = "";
    String tipo = "success";

    if (mensaje != null) {

        switch (mensaje) {

            case "registrado_ok":
                texto = "Médico registrado correctamente.";
                tipo = "success";
                break;

            case "actualizado_ok":
                texto = "Médico actualizado correctamente.";
                tipo = "success";
                break;

            case "eliminado_ok":
                texto = "Médico eliminado correctamente.";
                tipo = "success";
                break;

            case "estado_ok":
                texto = "Estado actualizado correctamente.";
                tipo = "success";
                break;

            case "error":
                texto = "Ocurrió un error en la operación.";
                tipo = "danger";
                break;
        }
    }
%>   

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración de Médicos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
            padding-top: 80px;
        }
        main { flex: 1; }
        .navbar-custom { background-color: #0DDBA0; z-index: 1030; }
        footer { background-color: #0DDBA0; color: white; padding: 15px; text-align: center; }
        .btn-custom {
            background-color: #0DDBA0;
            color: white;
            font-weight: bold;
            border-radius: 30px;
            transition: transform .15s ease;
        }
        .btn-custom:hover { transform: translateY(-2px); background-color: #0bbd8a; }

        .card { border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,0.06); }
        table thead { background-color: #0DDBA0; color: white; }
        .table-hover tbody tr:hover { background-color: rgba(13,219,160,0.06); }

        .navbar-nav .nav-link.active { text-decoration: underline; text-underline-offset: 6px; }
    </style>
</head>
<body>
<% if (mensaje != null) { %>

<div class="position-fixed top-0 end-0 p-3"
     style="z-index: 9999">

    <div id="toastMensaje"
         class="toast align-items-center text-bg-<%= tipo %> border-0"
         role="alert">

        <div class="d-flex">

            <div class="toast-body">
                <%= texto %>
            </div>

            <button type="button"
                    class="btn-close btn-close-white me-2 m-auto"
                    data-bs-dismiss="toast">
            </button>

        </div>

    </div>

</div>

<% } %>

<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold text-white" href="<%= request.getContextPath() %>/PaginaPrincipal.jsp">TeleMedicina Perú</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
            <a class="nav-link text-white fw-semibold " href="<%= request.getContextPath() %>/DashboardAdmin">Dashboard</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold active" href="<%= request.getContextPath() %>/AdministracionMedico">Médicos</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionPaciente">Pacientes</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/PublicacionServlet">Publicaciones</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionCita">Citas</a>
          </li>
         
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/PaginaPrincipal.jsp">Cerrar sesión</a>
          </li>
        </ul>
        </div>
    </div>
</nav>

<main class="container my-4">

    <h2 class="text-center mb-4 fw-bold" style="color:#0DDBA0;">Administración de Médicos</h2>
    <div class="d-flex justify-content-end mb-4">
        <a href="FormularioMedico.jsp" class="btn btn-success">Agregar Médico</a>
    </div>

    <div class="card p-3">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>Nombre</th>
                        <th>Especialidad</th>
                        <th>Teléfono</th>
                        <th>Email</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Medico> medicos = (List<Medico>) request.getAttribute("medicos");
                        if (medicos != null && !medicos.isEmpty()) {
                            for (Medico medico : medicos) {
                    %>
                        <tr>
                            <td><%= medico.getNombre() %> <%= medico.getApellido() %></td>
                            <td><%= medico.getEspecialidad() %></td>
                            <td><%= medico.getTelefono() %></td>
                            <td><%= medico.getCorreo() %></td>
                            <td>
                                <% if("Bloqueado".equalsIgnoreCase(medico.getEstado())) { %>

                                    <span class="badge bg-danger">
                                        Bloqueado
                                    </span>

                                <% } else { %>

                                    <span class="badge bg-success">
                                        Activo
                                    </span>

                                <% } %>
                            </td>
                            <td>

                            <!-- EDITAR -->
                            <a href="<%= request.getContextPath() %>/AdministracionMedico?accion=editar&id=<%= medico.getIdMedico() %>"
                               class="btn btn-warning btn-sm">

                                Editar
                            </a>

                            <!-- ELIMINAR -->
                            <a href="<%= request.getContextPath() %>/AdministracionMedico?accion=eliminar&id=<%= medico.getIdMedico() %>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('¿Seguro que deseas eliminar a <%= medico.getNombre() %> <%= medico.getApellido() %>?');">

                                Eliminar
                            </a>

                            <!-- ESTADO -->
                            <button
                                type="button"
                                class="btn btn-secondary btn-sm"
                                data-bs-toggle="modal"
                                data-bs-target="#modalEstado"

                                data-id="<%= medico.getIdUsuario() %>"
                                data-nombre="<%= medico.getNombre() %> <%= medico.getApellido() %>"
                                data-estado="<%= medico.getEstado() %>"
                                data-info="<%= medico.getInfo() %>">

                                Estado
                            </button>

                        </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center text-muted">No hay médicos registrados.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<footer>
    <p class="mb-0">© 2025 TeleMedicina Perú | Todos los derechos reservados</p>
</footer>
<!-- MODAL CAMBIO ESTADO -->
<div class="modal fade" id="modalEstado" tabindex="-1">

    <div class="modal-dialog">

        <div class="modal-content">

            <form action="AdministracionMedico" method="post">

                <div class="modal-header">

                    <h5 class="modal-title">
                        Cambiar Estado de Cuenta
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body">

                    <input type="hidden"
                           name="accion"
                           value="estado">

                    <input type="hidden"
                           name="idUsuario"
                           id="idUsuarioModal">

                    <p id="nombreUsuario"></p>

                    <label class="form-label">
                        Estado
                    </label>

                    <select name="estado"
                            id="estadoModal"
                            class="form-select"
                            required>

                        <option value="Activo">
                            Activo
                        </option>

                        <option value="Bloqueado">
                            Bloqueado
                        </option>

                    </select>

                    <label class="form-label mt-3">
                        Motivo
                    </label>

                    <textarea
                        name="info"
                        id="infoModal"
                        class="form-control"
                        rows="4">
                    </textarea>

                </div>

                <div class="modal-footer">

                    <button type="submit"
                            class="btn btn-success">

                        Guardar
                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function(){
        const linkMedicos = document.getElementById('link-medicos');
        if(linkMedicos) linkMedicos.classList.add('active');
    })();
    
    const modalEstado = document.getElementById('modalEstado');

    modalEstado.addEventListener('show.bs.modal', function(event){

        const button = event.relatedTarget;

        const idUsuario = button.getAttribute('data-id');

        const nombre = button.getAttribute('data-nombre');

        const estado = button.getAttribute('data-estado');

        const info = button.getAttribute('data-info');

        document.getElementById('idUsuarioModal').value = idUsuario;

        document.getElementById('nombreUsuario').innerHTML =
            "Usuario: <b>" + nombre + "</b>";

        // CARGAR ESTADO
        document.getElementById('estadoModal').value = estado;

        // CARGAR INFO
        document.getElementById('infoModal').value =
            (info === "null" || info === null)
            ? ""
            : info;
    });
    <% if (mensaje != null) { %>

    const toastElement = document.getElementById('toastMensaje');

    const toast = new bootstrap.Toast(toastElement, {
        delay: 3000
    });

    toast.show();

    <% } %>
</script>

</body>
</html>