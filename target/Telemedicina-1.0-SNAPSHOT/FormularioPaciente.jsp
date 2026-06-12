<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Paciente"%>
<%@page import="modelo.Usuario"%>
<%
    Paciente paciente = (Paciente) request.getAttribute("paciente");
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    boolean esEdicion = (paciente != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar Paciente" : "Registrar Paciente" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .btn-custom { background-color:#0DDBA0; color:white; }
    </style>
</head>
<body>
<div class="container mt-5 mb-5">
    <h2 class="text-center mb-4" style="color:#0DDBA0;">
        <%= esEdicion ? "Editar Datos del Paciente" : "Agregar Nuevo Paciente" %>
    </h2>

    <form action="<%= request.getContextPath() %>/SvRegistroPaciente" method="post">
        <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "agregar" %>">

        <% if (esEdicion) { %>
            <input type="hidden" name="idPaciente" value="<%= paciente.getIdPaciente() %>">
            <input type="hidden" name="idUsuario" value="<%= usuario != null ? usuario.getIdUsuario() : "" %>">
        <% } %>

        <!-- 🧍 Información Personal -->
        <h5>Información Personal</h5>
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Nombre *</label>
                <input type="text" name="nombres" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getNombre() : "" %>">
            </div>
            <div class="col">
                <label class="form-label">Apellido *</label>
                <input type="text" name="apellidos" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getApellido() : "" %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Fecha de Nacimiento *</label>
                <input type="date" name="fechaNacimiento" class="form-control" required
                       value="<%= esEdicion && usuario != null && usuario.getFechaNacimiento()!=null ? usuario.getFechaNacimiento() : "" %>">
            </div>
            <div class="col">
                <label class="form-label">Correo Electrónico *</label>
                <input type="email" name="correo" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getCorreo() : "" %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Dirección *</label>
                <input type="text" name="direccion" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getDireccion() : "" %>">
            </div>
            <div class="col">
                <label class="form-label">Teléfono *</label>
                <input type="text" name="telefono" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getTelefono() : "" %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <label class="form-label">Tipo de Documento *</label>
                <select name="tipoDocumento" class="form-select" required>
                    <option value="">Seleccione...</option>
                    <option value="DNI" <%= esEdicion && usuario!=null && "DNI".equals(usuario.getTipoDocumento()) ? "selected" : "" %>>DNI</option>
                    <option value="CE" <%= esEdicion && usuario!=null && "CE".equals(usuario.getTipoDocumento()) ? "selected" : "" %>>CE</option>
                    <option value="Pasaporte" <%= esEdicion && usuario!=null && "Pasaporte".equals(usuario.getTipoDocumento()) ? "selected" : "" %>>Pasaporte</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">N° Documento *</label>
                <input type="text" name="numeroDocumento" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getNumeroDocumento() : "" %>">
            </div>
            <div class="col-md-4">
                <label class="form-label">Género *</label>
                <select name="genero" class="form-select" required>
                    <option value="">Seleccione...</option>
                    <option value="Masculino" <%= esEdicion && usuario!=null && "Masculino".equals(usuario.getGenero()) ? "selected" : "" %>>Masculino</option>
                    <option value="Femenino" <%= esEdicion && usuario!=null && "Femenino".equals(usuario.getGenero()) ? "selected" : "" %>>Femenino</option>
                    <option value="Otro" <%= esEdicion && usuario!=null && "Otro".equals(usuario.getGenero()) ? "selected" : "" %>>Otro</option>
                </select>
            </div>
        </div>

        <% if (!esEdicion) { %>
            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">Contraseña *</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
            </div>
        <% } %>

        <!-- 🩺 Información Médica -->
        <h5 class="mt-4">Información Médica</h5>
        <div class="row mb-3">
            <div class="col-md-4">
                <label class="form-label">Grupo Sanguíneo *</label>
                <select name="grupoSanguineo" class="form-select" required>
                    <option value="">Seleccione...</option>
                    <%
                        String grupo = esEdicion && paciente != null ? paciente.getGrupoSanguineo() : "";
                        String[] grupos = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                        for (String g : grupos) {
                    %>
                        <option value="<%= g %>" <%= g.equals(grupo) ? "selected" : "" %>><%= g %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">Peso (kg)</label>
                <input type="number" step="0.01" name="peso" class="form-control"
                       value="<%= esEdicion && paciente != null && paciente.getPeso()!=null ? paciente.getPeso() : "" %>">
            </div>
            <div class="col-md-4">
                <label class="form-label">Altura (m)</label>
                <input type="number" step="0.01" name="altura" class="form-control"
                       value="<%= esEdicion && paciente != null && paciente.getAltura()!=null ? paciente.getAltura() : "" %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Alergias</label>
                <textarea name="alergias" class="form-control" rows="2"><%= esEdicion && paciente != null ? paciente.getAlergias() : "" %></textarea>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Historial Clínico</label>
            <textarea name="historialClinico" class="form-control" rows="3"><%= esEdicion && paciente != null ? paciente.getHistorialClinico() : "" %></textarea>
        </div>

                <button type="submit" class="btn btn-custom"><%= esEdicion ? "Actualizar Paciente" : "Registrar Paciente" %></button>
        <a href="AdministracionPaciente" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
