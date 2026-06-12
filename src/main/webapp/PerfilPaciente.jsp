<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@page import="modelo.Paciente"%>
<%
    // 1. VALIDACIÓN DE SESIÓN Y ROL
    String rol = (String) session.getAttribute("rol");
    if (rol == null || !"PACIENTE".equalsIgnoreCase(rol)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%
    // 2. OBTENER OBJETO PACIENTE DE LA SESIÓN
    Paciente paciente = (Paciente) session.getAttribute("paciente");
    
    // Si el objeto no existe, redirige (doble verificación de seguridad)
    if (paciente == null) {
        response.sendRedirect("login.jsp"); 
        return;
    }
    boolean esEdicion = true;
    String nombrePaciente = paciente.getNombre() + " " + paciente.getApellido();
    
    //AGREGADO PARA LA FOTO DEL PACIENTE 
    
%>
<!DOCTYPE html> 
<html lang="es"> 
<head> 
    <meta charset="UTF-8"> 
    <title>Mi Perfil - TELEMED</title>
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
        .card-title {
            color: var(--color-principal);
        }
        .btn-primary {
            background-color: var(--color-principal);
            border: none;
        }
        .btn-primary:hover {
            background-color: #0ab391;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">TELEMED</a>
        <div class="collapse navbar-collapse" id="navbarPaciente">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="SvPublicacionesPaciente">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=citas">Mis Citas</a></li>
                <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=diagnosticos">Mis Diagnósticos</a></li>
                <li class="nav-item"><a class="nav-link" href="ServicioPaciente.jsp">Servicios</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
            </ul>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    Hola, <%= nombrePaciente %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                    <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5 pt-4">
    <div class="card shadow-sm p-4">
        <h3 class="card-title mb-4">Editar Mi Perfil</h3>
        
        <% 
        String exito = request.getParameter("exito");
        String error = request.getParameter("error");
        
        // Manejo de Mensajes de Alerta
        if (exito != null) { 
        %>
            <div class="alert alert-success">Perfil actualizado correctamente.</div>
        <% 
        } else if (error != null) { 
            if (error.equals("format_peso")) { 
        %>
                <div class="alert alert-warning">❌ **Error:** El valor del **Peso** no es un número válido. Por favor, corríjalo (use punto decimal si es necesario).</div>
            <% } else if (error.equals("format_altura")) { %>
                <div class="alert alert-warning">❌ **Error:** El valor de la **Altura** no es un número válido. Por favor, corríjalo (use punto decimal si es necesario).</div>
            <% } else if (error.equals("sql")) { %>
                <div class="alert alert-danger">Hubo un error de conexión o de base de datos al actualizar el perfil.</div>
            <% } else { %>
                <div class="alert alert-danger">Hubo un error al actualizar el perfil.</div>
            <% } %>
        <% } %>

        <form action="SvActualizarPaciente" method="post">
            <input type="hidden" name="idPaciente" value="<%= paciente.getIdPaciente() %>">

            <h4>Datos Personales (Usuario)</h4>
            <hr>
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Nombre</label>
                    <input type="text" name="nombre" class="form-control" 
                           value="<%= paciente.getNombre() %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Apellido</label>
                    <input type="text" name="apellido" class="form-control" 
                           value="<%= paciente.getApellido() %>" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" name="correo" class="form-control" 
                           value="<%= paciente.getCorreo() %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Teléfono</label>
                    <input type="text" name="telefono" class="form-control" 
                           value="<%= paciente.getTelefono() != null ? paciente.getTelefono() : "" %>">
                </div>
            </div>
            
            <h4 class="mt-4">Información Médica (Paciente)</h4>
            <hr>

                <div class="row mb-3">

                    <div class="col-md-4">
                        <label class="form-label">Grupo Sanguíneo</label>
                        <select name="grupoSanguineo" class="form-control">

                            <option value="" <%= paciente.getGrupoSanguineo() == null || paciente.getGrupoSanguineo().isEmpty() ? "selected" : "" %>>
                                Seleccione
                            </option>

                            <%-- Los valores disponibles --%>
                            <% 
                                String actualGrupo = paciente.getGrupoSanguineo();
                                String[] grupos = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};

                                for (String grupo : grupos) {
                                    String selectedAttr = (actualGrupo != null && actualGrupo.equals(grupo)) ? "selected" : "";
                            %>
                                <option value="<%= grupo %>" <%= selectedAttr %>><%= grupo %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Peso (kg)</label>
                        <input type="number" step="0.01" name="peso" class="form-control"
                                value="<%= esEdicion && paciente != null && paciente.getPeso()!=null ? paciente.getPeso().toString() : "" %>">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Altura (m)</label>
                        <input type="number" step="0.01" name="altura" class="form-control"
                                value="<%= esEdicion && paciente != null && paciente.getAltura()!=null ? paciente.getAltura().toString() : "" %>">
                    </div>

                </div>
            <div class="mb-3">
                <label class="form-label">Alergias</label>
                <textarea name="alergias" class="form-control" rows="3"><%= paciente.getAlergias() != null ? paciente.getAlergias() : "" %></textarea>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Historial Clínico Relevante</label>
                <textarea name="historialClinico" class="form-control" rows="5"><%= paciente.getHistorialClinico() != null ? paciente.getHistorialClinico() : "" %></textarea>
            </div>


            <div class="d-flex justify-content-between mt-4">
                <a href="SvPublicacionesPaciente" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>