<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Medico"%>
<%@page import="modelo.Usuario"%>
<%
    Medico medico = (Medico) request.getAttribute("medico");
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    boolean esEdicion = (medico != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= esEdicion ? "Editar Médico" : "Registrar Médico" %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .btn-custom { background-color:#0DDBA0; color:white; }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="text-center mb-4" style="color:#0DDBA0;">
        <%= esEdicion ? "Editar Datos del Médico" : "Agregar Nuevo Médico" %>
    </h2>

    <form action="<%= request.getContextPath() %>/SvRegistroMedico" method="post">
        <%-- indicador de acción (opcional) --%>
        <input type="hidden" name="accion" value="<%= esEdicion ? "actualizar" : "agregar" %>">
        <% if (esEdicion) { %>
            <input type="hidden" name="idMedico" value="<%= medico.getIdMedico() %>">
            <input type="hidden" name="idUsuario" value="<%= medico.getIdUsuario() %>">
        <% } %>

        <!-- Información personal (usamos usuario si está disponible) -->
        <h5>Información Personal</h5>
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Nombre *</label>
                <input type="text" name="nombres" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getNombre() : (request.getParameter("nombres")!=null?request.getParameter("nombres"):"") %>">
            </div>
            <div class="col">
                <label class="form-label">Apellido *</label>
                <input type="text" name="apellidos" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getApellido() : (request.getParameter("apellidos")!=null?request.getParameter("apellidos"):"") %>">
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Fecha de Nacimiento</label>
            <input type="date" name="fechaNacimiento" class="form-control"
                   value="<%= esEdicion && usuario != null && usuario.getFechaNacimiento() != null ? usuario.getFechaNacimiento() : (request.getParameter("fechaNacimiento")!=null?request.getParameter("fechaNacimiento"):"") %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Correo Electrónico *</label>
            <input type="email" name="correo" class="form-control" required
                   value="<%= esEdicion && usuario != null ? usuario.getCorreo() : (request.getParameter("correo")!=null?request.getParameter("correo"):"") %>">
        </div>

        <% if (!esEdicion) { %>
            <div class="mb-3">
                <label class="form-label">Contraseña *</label>
                <input type="password" name="password" class="form-control" required>
            </div>
        <% } %>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Teléfono *</label>
                <input type="text" name="telefono" class="form-control" required
                       value="<%= esEdicion && usuario != null ? usuario.getTelefono() : (request.getParameter("telefono")!=null?request.getParameter("telefono"):"") %>">
            </div>
            <div class="col">
                <label class="form-label">Dirección</label>
                <input type="text" name="direccion" class="form-control"
                       value="<%= esEdicion && usuario != null ? usuario.getDireccion() : (request.getParameter("direccion")!=null?request.getParameter("direccion"):"") %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Tipo de Documento</label>
                <select name="tipoDocumento" class="form-select">
                    <option value="">Seleccione...</option>
                    <option value="DNI" <%= (esEdicion && usuario!=null && "DNI".equals(usuario.getTipoDocumento())) ? "selected" : "" %>>DNI</option>
                    <option value="CE" <%= (esEdicion && usuario!=null && "CE".equals(usuario.getTipoDocumento())) ? "selected" : "" %>>CE</option>
                    <option value="Pasaporte" <%= (esEdicion && usuario!=null && "Pasaporte".equals(usuario.getTipoDocumento())) ? "selected" : "" %>>Pasaporte</option>
                </select>
            </div>
            <div class="col">
                <label class="form-label">Número de Documento</label>
                <input type="text" name="numeroDocumento" class="form-control"
                       value="<%= esEdicion && usuario != null ? usuario.getNumeroDocumento() : (request.getParameter("numeroDocumento")!=null?request.getParameter("numeroDocumento"):"") %>">
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Género</label>
                <select name="genero" class="form-select">
                    <option value="">Seleccione...</option>
                    <option value="Masculino" <%= (esEdicion && usuario!=null && "Masculino".equals(usuario.getGenero())) ? "selected" : "" %>>Masculino</option>
                    <option value="Femenino" <%= (esEdicion && usuario!=null && "Femenino".equals(usuario.getGenero())) ? "selected" : "" %>>Femenino</option>
                    <option value="Otro" <%= (esEdicion && usuario!=null && "Otro".equals(usuario.getGenero())) ? "selected" : "" %>>Otro</option>
                </select>
            </div>
        </div>

        <!-- Información Profesional -->
        <h5 class="mt-4">Información Profesional</h5>
        <div class="mb-3">
            <label class="form-label">Nro. de Colegiatura *</label>
            <input type="text" name="nroColegiatura" class="form-control" required
                   value="<%= esEdicion && medico != null ? medico.getNroColegiatura() : (request.getParameter("nroColegiatura")!=null?request.getParameter("nroColegiatura"):"") %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Especialidad *</label>
            <input type="text" name="especialidad" class="form-control" required
                   value="<%= esEdicion && medico != null ? medico.getEspecialidad() : (request.getParameter("especialidad")!=null?request.getParameter("especialidad"):"") %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Centro Laboral</label>
            <input type="text" name="centroLaboral" class="form-control"
                   value="<%= esEdicion && medico != null ? medico.getCentroLaboral() : (request.getParameter("centroLaboral")!=null?request.getParameter("centroLaboral"):"") %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Años de Experiencia</label>
            <input type="number" name="aniosExperiencia" class="form-control" min="0"
                   value="<%= esEdicion && medico != null ? medico.getAniosExperiencia() : (request.getParameter("aniosExperiencia")!=null?request.getParameter("aniosExperiencia"):"") %>">
        </div>

        <div class="mb-3">
            <label class="form-label">Descripción Profesional</label>
            <textarea name="descripcion" class="form-control" rows="3"><%= esEdicion && medico != null ? medico.getDescripcion() : (request.getParameter("descripcion")!=null?request.getParameter("descripcion"):"") %></textarea>
        </div>
        <button type="submit" class="btn btn-custom"><%= esEdicion ? "Actualizar Médico" : "Registrar Médico" %></button>
        <a href="AdministracionMedico" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
