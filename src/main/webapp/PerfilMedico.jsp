<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page session="true" %>
<%
    // Validar sesión del médico
    String rol = (String) session.getAttribute("rol");

    // NO AUTENTICADO
    if(rol == null){

        response.sendRedirect("login.jsp");
        return;
    }

    // AUTENTICADO PERO NO ES ADMIN
    if(!rol.equals("MEDICO")){

        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }
%>

<%
modelo.Medico medico = (modelo.Medico) session.getAttribute("medico");
String nombreMedico = "Invitado";
if (medico != null) {
nombreMedico = medico.getNombre() + " " + medico.getApellido();
}
%>
<!DOCTYPE html> <html lang="es"> <head> <meta charset="UTF-8"> <title>Perfil Médico - TELEMED</title>
        <!-- Bootstrap -->
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
<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">TELEMED</a>
        <div class="collapse navbar-collapse" id="navbarDoctor">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item">
    <a class="nav-link" href="<%= request.getContextPath() %>/SvPublicacion">Inicio</a>
</li>
                <li class="nav-item"><a class="nav-link" href="SvCitasPendientesMedico">Citas Pendientes</a></li>
                <li class="nav-item"><a class="nav-link" href="SvCitasCompletadasMedico">Citas Completadas</a></li>
                <li class="nav-item"><a class="nav-link active" href="PerfilMedico.jsp">Perfil Médico</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
            </ul>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    Dr. <%= nombreMedico %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                    <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Contenido -->
<div class="container mt-5 pt-4">
    <div class="card shadow-sm p-4">
        <h3 class="card-title mb-4">Editar Perfil del Doctor</h3>
        <% if (request.getParameter("exito") != null) { %>
<div class="alert alert-success">Perfil actualizado correctamente.</div>
<% } else if (request.getParameter("error") != null) { %>
<div class="alert alert-danger">Hubo un error al actualizar el perfil.</div>
<% } %>

        <form action="SvActualizarMedico" method="post" enctype="multipart/form-data">

            <input type="hidden" name="idMedico" value="<%= medico != null ? medico.getIdMedico() : 0 %>">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Nombre</label>
                    <input type="text" name="nombre" class="form-control" 
                           value="<%= medico != null ? medico.getNombre() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Apellido</label>
                    <input type="text" name="apellido" class="form-control" 
                           value="<%= medico != null ? medico.getApellido() : "" %>" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Correo Electrónico</label>
                    <input type="email" name="correo" class="form-control" 
                           value="<%= medico != null ? medico.getCorreo() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Teléfono</label>
                    <input type="text" name="telefono" class="form-control" 
                           value="<%= medico != null ? medico.getTelefono() : "" %>">
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Especialidad</label>
                    <input type="text" name="especialidad" class="form-control" 
                           value="<%= medico != null ? medico.getEspecialidad() : "" %>" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Número de Colegiatura (CIP)</label>
                    <input type="text" name="nroColegiatura" class="form-control" 
                           value="<%= medico != null ? medico.getNroColegiatura() : "" %>" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label class="form-label">Años de Experiencia</label>
                    <input type="number" name="aniosExperiencia" class="form-control"
                    value="<%= (medico != null) ? medico.getAniosExperiencia() : 0 %>" min="0">
                </div>
                <div class="col-md-8">
                    <label class="form-label">Centro Laboral</label>
                    <input type="text" name="centroLaboral" class="form-control" 
                           value="<%= medico != null ? medico.getCentroLaboral() : "" %>">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Descripción Profesional</label>
                <textarea name="descripcion" class="form-control" rows="3"><%= medico != null ? medico.getDescripcion() : "" %></textarea>
            </div>
            <div class="mb-3">
    <label class="form-label">Foto de Perfil</label>
    <input type="file" name="fotoPerfil" class="form-control" accept="image/*">

    <% if (medico != null && medico.getFotoPerfil() != null) { %>
        <div class="mt-3">
            <p class="fw-bold">Foto actual:</p>
            <img src="data:image/jpeg;base64,<%= 
                    java.util.Base64.getEncoder().encodeToString(medico.getFotoPerfil())
                %>" 
                alt="Foto de perfil" 
                class="img-thumbnail"
                style="max-width: 180px; border:2px solid #0DDBA0;">
        </div>
    <% } %>
</div>



            <div class="d-flex justify-content-between">
                <a href="HomeMedico.jsp" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
