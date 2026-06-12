<%@ page contentType="text/html" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ page import="modelo.Publicacion" %>
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

    modelo.Medico medico = (modelo.Medico) session.getAttribute("medico");
    String nombreCompleto = "Invitado";
    //ESTO  SE MODIFICA PARA VISUALZIAR FOTO DEL MEDICO
    String fotoMedicoBase64 = null; 
    
    if (medico != null) {
        nombreCompleto = medico.getNombre() + " " + medico.getApellido();
        
        // Convertir byte[] a Base64 String
        if (medico.getFotoPerfil() != null && medico.getFotoPerfil().length > 0) {
            fotoMedicoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(medico.getFotoPerfil());
        }
    }

    List<Publicacion> publicaciones = (List<Publicacion>) request.getAttribute("publicaciones");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio Médico - TELEMED</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
        body { background-color: var(--color-secundario); padding-top: 80px; }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .card-title { color: var(--color-principal); }
        .btn-primary { background-color: var(--color-principal); border: none; }
        .btn-primary:hover { background-color: #0ab391; }
        .new-post-form {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 25px;
        }
        .post-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .post-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .post-header {
            display: flex;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #f0f0f0;
        }
        .doctor-avatar {
            width: 50px; height: 50px; border-radius: 50%;
            background: linear-gradient(135deg, var(--color-principal), #0ab391);
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: bold; font-size: 20px;
        }
        .doctor-info { margin-left: 12px; flex-grow: 1; }
        .doctor-name { font-weight: 600; color: #333; margin: 0; }
        .post-time { font-size: 13px; color: #666; }
        .post-category {
            display: inline-block; padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 500;
        }
        .category-receta { background: #e8f5e9; color: #2e7d32; }
        .category-consejo { background: #e3f2fd; color: #1565c0; }
        .category-alimentacion { background: #fff8e1; color: #f57f17; }
        .category-ejercicio { background: #e1f5fe; color: #0277bd; }
        .category-bienestar { background: #f3e5f5; color: #6a1b9a; }
        .post-content { padding: 20px; }
        .post-title { font-size: 18px; font-weight: 600; color: #333; margin-bottom: 10px; }
        .post-text { color: #555; line-height: 1.6; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">TELEMED</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <a class="nav-link active" href="<%= request.getContextPath() %>/SvPublicacion">Inicio</a>
                <li class="nav-item"><a class="nav-link" href="SvCitasPendientesMedico">Citas Pendientes</a></li>
                <li class="nav-item"><a class="nav-link" href="SvCitasCompletadasMedico">Citas Completadas</a></li>
                <li class="nav-item"><a class="nav-link" href="PerfilMedico.jsp">Perfil Médico</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
            </ul>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle fw-bold" type="button" data-bs-toggle="dropdown">
                    Dr. <%= nombreCompleto %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end">
                    <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<!-- Contenido principal -->
<div class="container mt-4">
    <div class="col-lg-8 mx-auto">
        <!-- Mensajes -->
        <% if (request.getAttribute("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= request.getAttribute("mensaje") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Bienvenida -->
        <div class="card shadow-sm p-3 mb-4">
            <h4 class="card-title mb-1">Bienvenido Dr. <%= nombreCompleto %></h4>
            <p class="text-muted mb-0">Comparte tus consejos o publicaciones con tus pacientes</p>
        </div>

        <!-- Formulario -->
        <div class="new-post-form">
            <h5 class="mb-3"><i class="fas fa-pen-to-square me-2"></i>Crear nueva publicación</h5>
            <form action="SvPublicacion" method="post">
                <input type="hidden" name="id_medico" value="<%= medico.getIdMedico() %>">
                <div class="mb-3">
                    <label class="form-label">Categoría</label>
                    <select class="form-select" name="id_categoria" required>
                        <option value="">Seleccionar...</option>
                        <option value="1">Receta Natural</option>
                        <option value="2">Consejo de Salud</option>
                        <option value="3">Alimentación Saludable</option>
                        <option value="4">Ejercicio</option>
                        <option value="5">Bienestar Mental</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Título</label>
                    <input type="text" class="form-control" name="titulo" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Contenido</label>
                    <textarea class="form-control" name="contenido" rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane me-2"></i>Publicar
                </button>
            </form>
        </div>

        <!-- Publicaciones -->
        <div id="postsContainer">
            <% if (publicaciones == null || publicaciones.isEmpty()) { %>
                <p class="text-muted text-center">Aún no has realizado publicaciones.</p>
            <% } else { 
                for (Publicacion pub : publicaciones) {
                    String iniciales = nombreCompleto.length() > 2 ?
                        nombreCompleto.substring(0, 1).toUpperCase() + 
                        nombreCompleto.substring(nombreCompleto.indexOf(" ") + 1, nombreCompleto.indexOf(" ") + 2).toUpperCase() : "DR";
            %>
            <div class="post-card mb-4">
                <div class="post-header">
                    <% if (fotoMedicoBase64 != null) { %>
                        <img src="<%= fotoMedicoBase64 %>" class="doctor-avatar" style="object-fit: cover; background: none;">
                    <% } else { %>
                        <div class="doctor-avatar"><%= iniciales %></div>
                    <% } %>
                    
                    <div class="doctor-info">
                        <p class="doctor-name">Dr. <%= nombreCompleto %></p>
                        <p class="post-time"><%= pub.getFechaPublicacion() %></p>
                    </div>
                    <span class="post-category 
                        <%= pub.getIdCategoria()==1?"category-receta":
                            pub.getIdCategoria()==2?"category-consejo":
                            pub.getIdCategoria()==3?"category-alimentacion":
                            pub.getIdCategoria()==4?"category-ejercicio":
                            "category-bienestar" %>">
                        <%= pub.getNombreCategoria() %>
                    </span>
                </div>
                <div class="post-content">
                    <h5 class="post-title"><%= pub.getTitulo() %></h5>
                    <p class="post-text"><%= pub.getContenido() %></p>
                </div>
            </div>
            <% } } %>
        </div>
    </div>
</div>

</body>
</html>
