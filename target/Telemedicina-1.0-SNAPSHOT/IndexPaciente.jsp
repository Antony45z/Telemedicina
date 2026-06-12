<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="modelo.Usuario, java.util.Base64" %>
<%@page session="true"%>
<%@ page import="java.util.List" %>
<%@ page import="modelo.Publicacion" %>
<% 
    List<Publicacion> publicaciones = (List<Publicacion>) request.getAttribute("publicaciones");
%>
<%@ page import="modelo.Medico, java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <title>TELEMED</title>
  <style>
      :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
  body {
    padding-top: 70px; /* espacio para navbar fijo */
  }
  

  /* Navbar */
  .navbar-brand {
    font-weight: bold;
    color: #0DDBA0 !important;
  }

    /* Estilos para publicaciones */
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
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0DDBA0, #0ab391);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
        }
        .doctor-info {
            margin-left: 12px;
            flex-grow: 1;
        }
        .doctor-name {
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .post-time {
            font-size: 13px;
            color: #666;
        }
        .post-category {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        .category-receta {
            background: #e8f5e9;
            color: #2e7d32;
        }
        .category-remedio {
            background: #fff3e0;
            color: #e65100;
        }
        .category-consejo {
            background: #e3f2fd;
            color: #1565c0;
        }
        .post-content {
            padding: 20px;
        }
        .post-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .post-text {
            color: #555;
            line-height: 1.6;
        }
        .post-image {
            width: 100%;
            border-radius: 8px;
            margin-top: 15px;
        }
        .post-footer {
            padding: 12px 20px;
            border-top: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-around;
        }
        .reaction-btn {
            background: none;
            border: none;
            color: #666;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            padding: 8px 15px;
            border-radius: 8px;
        }
        .reaction-btn:hover {
            background: #f5f5f5;
        }
        .reaction-btn.active {
            color: #0DDBA0;
            font-weight: 600;
        }
        .reaction-btn i {
            margin-right: 5px;
        }
        .comments-section {
            padding: 15px 20px;
            border-top: 1px solid #f0f0f0;
            background: #fafafa;
            display: none;
        }
        .comment {
            display: flex;
            margin-bottom: 12px;
            padding: 10px;
            background: white;
            border-radius: 8px;
        }
        .comment-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            background: #ddd;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            color: #666;
            flex-shrink: 0;
        }
        .comment-content {
            margin-left: 10px;
            flex-grow: 1;
        }
        .comment-author {
            font-weight: 600;
            font-size: 14px;
            color: #333;
        }
        .comment-text {
            font-size: 14px;
            color: #555;
            margin-top: 3px;
        }
        .comment-input-group {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        /* Banner bienvenida */
        .welcome-banner {
            background: linear-gradient(135deg, #0DDBA0, #0ab391);
            color: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(13, 219, 160, 0.3);
        }
        .welcome-banner h2 {
            color: white;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .welcome-banner p {
            color: rgba(255,255,255,0.95);
            font-size: 16px;
        }

        /* Filtros */
        .filter-pills {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .filter-pill {
            padding: 8px 20px;
            border-radius: 25px;
            border: 2px solid #0DDBA0;
            background: white;
            color: #0DDBA0;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }
        .filter-pill:hover, .filter-pill.active {
            background: #0DDBA0;
            color: white;
        }

        /* Sidebar */
        .sidebar-widget {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .sidebar-widget h5 {
            color: #0DDBA0;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .doctor-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 10px;
            transition: background 0.2s;
            cursor: pointer;
        }
        .doctor-item:hover {
            background: #f5f5f5;
        }
        .doctor-item-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #0DDBA0, #0ab391);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 12px;
        }
        .nav-link.active {
            color: var(--color-principal) !important;
            font-weight: bold;
        }
</style>

</head>
<body>



<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    String rol = (String) session.getAttribute("rol");

    // VALIDAR SESIÓN
    if (usuario == null) {

        response.sendRedirect("login.jsp");
        return;
    }

    // VALIDAR SESIÓN
    if (usuario == null || rol == null) {

        response.sendRedirect("login.jsp");
        return;
    }

    // VALIDAR ROL
    if (!rol.equalsIgnoreCase("PACIENTE")) {

        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }

    String nombre = usuario.getNombre() + " " + usuario.getApellido();

    String inicial = usuario.getNombre()
                             .substring(0, 1)
                             .toUpperCase();
    String fotoBase64 = null;

    byte[] foto = usuario.getFotoPerfil();
    if (foto != null && foto.length > 0) {
        fotoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(foto);
    }
%>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid #0DDBA0;">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">TELEMED</a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMenu">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarMenu">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link active" href="SvPublicacionesPaciente">Inicio</a></li>
        <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=citas">Mis Citas</a></li>
        <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=diagnosticos">Mis Diagnósticos</a></li>
        <li class="nav-item"><a class="nav-link" href="ServicioPaciente.jsp">Servicios</a></li>
        <li class="nav-item"><a class="nav-link" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
      </ul>

      <!-- Perfil -->
      <div class="d-flex align-items-center">
        <% if (fotoBase64 != null) { %>
          <img src="<%= fotoBase64 %>" class="rounded-circle me-2" width="40" height="40" style="object-fit: cover;">
        <% } else { %>
          <div class="rounded-circle d-flex align-items-center justify-content-center me-2"
               style="width:40px;height:40px;background-color:#0DDBA0;color:white;font-weight:bold;font-size:18px;">
            <%= inicial %>
          </div>
        <% } %>

        <div class="dropdown">
          <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="dropdownUser" data-bs-toggle="dropdown">
            <span><%= nombre %></span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end shadow">
            <li><a class="dropdown-item" href="PerfilPaciente.jsp">Mi Perfil</a></li>
            <!--<li><a class="dropdown-item" href="configuracion.jsp">Configuración</a></li>-->
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</nav>


<!-- Contenido Principal -->
<div class="container mt-4">
    <div class="row">
        <!-- Columna Principal (Feed) -->
        <div class="col-lg-8">
            <!-- Banner de Bienvenida -->
            <div class="welcome-banner">
                <h2>👋 ¡Hola, <%= usuario.getNombre() %>!</h2>
                <p>Descubre consejos de salud, recetas naturales y remedios caseros compartidos por nuestros médicos especialistas.</p>
            </div>

            <!-- Filtros de Categorías -->
            <div class="filter-pills">
                <button class="filter-pill active" onclick="filterPosts('all')">
                    <i class="fas fa-th-large me-1"></i>Todas
                </button>
                <button class="filter-pill" onclick="filterPosts('receta')">
                    🌿 Recetas Naturales
                </button>
           
                <button class="filter-pill" onclick="filterPosts('consejo')">
                    💡 Consejos de Salud
                </button>
                <button class="filter-pill" onclick="filterPosts('alimentacion')">
                    🏠 Alimentación Saludable
                </button>
                 <button class="filter-pill" onclick="filterPosts('ejercicio')">
                    💡 Ejercicio
                </button>
                 <button class="filter-pill" onclick="filterPosts('bienestar')">
                    💡 Bienestar Mental
                </button>
            </div>

       <!-- Feed de Publicaciones  ESTO ESTABA POR DEFECTO BY:CUADRA-->
<div id="postsContainer">
<% if (publicaciones == null || publicaciones.isEmpty()) { %>
    <p class="text-muted text-center">No hay publicaciones disponibles por ahora.</p>
<% } else { 
    for (Publicacion pub : publicaciones) {
        String doctorNombre = pub.getNombreMedico();
        
        // Lógica de Iniciales (se mantiene como respaldo)
        String iniciales = "DR";
        if (doctorNombre != null && doctorNombre.length() > 0) {
             iniciales = doctorNombre.substring(0, 1).toUpperCase();
             int espacio = doctorNombre.indexOf(" ");
             if (espacio > 0 && espacio + 1 < doctorNombre.length()) {
                 iniciales += doctorNombre.substring(espacio + 1, espacio + 2).toUpperCase();
             }
        }

        // 🟢 NUEVA LÓGICA: Convertir foto del médico a Base64
        String fotoPubBase64 = null;
        if (pub.getFotoMedico() != null && pub.getFotoMedico().length > 0) {
            fotoPubBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(pub.getFotoMedico());
        }
%>
<div class="post-card" 
     data-category="<%= pub.getNombreCategoria().toLowerCase().contains("receta") ? "receta" :
                       pub.getNombreCategoria().toLowerCase().contains("consejo") ? "consejo" :
                       pub.getNombreCategoria().toLowerCase().contains("alimentación") ? "alimentacion" :
                       pub.getNombreCategoria().toLowerCase().contains("ejercicio") ? "ejercicio" :
                       "bienestar" %>">
    
    <div class="post-header">
        <% if (fotoPubBase64 != null) { %>
            <img src="<%= fotoPubBase64 %>" class="doctor-avatar" style="object-fit: cover; background: none;">
        <% } else { %>
            <div class="doctor-avatar"><%= iniciales %></div>
        <% } %>

        <div class="doctor-info">
            <p class="doctor-name"><%= doctorNombre %></p>
            <p class="post-time"><%= pub.getFechaPublicacion() %></p>
        </div>
        <span class="post-category 
            <%= pub.getIdCategoria() == 1 ? "category-receta" :
                pub.getIdCategoria() == 2 ? "category-consejo" :
                pub.getIdCategoria() == 3 ? "category-alimentacion" :
                pub.getIdCategoria() == 4 ? "category-ejercicio" :
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
        <!-- Sidebar Derecha -->
        <div class="col-lg-4">
            <!-- Widget: Doctores Destacados -->
<div class="sidebar-widget">
    <h5><i class="fas fa-star me-2"></i>Doctores Destacados</h5>
    <%
        List<Medico> topDoctores = (List<Medico>) request.getAttribute("topDoctores");
        if (topDoctores != null && !topDoctores.isEmpty()) {
            for (Medico doc : topDoctores) {
                // 1. Lógica de iniciales
                String iniciales = "DR";
                if (doc.getNombre() != null && doc.getApellido() != null) {
                    iniciales = doc.getNombre().substring(0,1).toUpperCase() +
                                doc.getApellido().substring(0,1).toUpperCase();
                }

                // 2. NUEVA LÓGICA: Convertir foto del médico a Base64
                // IMPORTANTE: Verifica si en tu clase Medico el getter se llama getFotoPerfil() o getFoto()
                String fotoDocBase64 = null;
                if (doc.getFotoPerfil() != null && doc.getFotoPerfil().length > 0) {
                     fotoDocBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(doc.getFotoPerfil());
                }
    %>
    <div class="doctor-item">
        <% if (fotoDocBase64 != null) { %>
             <img src="<%= fotoDocBase64 %>" class="doctor-item-avatar" style="object-fit: cover;">
        <% } else { %>
             <div class="doctor-item-avatar"><%= iniciales %></div>
        <% } %>
        
        <div>
            <strong>Dr. <%= doc.getNombre() + " " + doc.getApellido() %></strong><br>
            <small class="text-muted"><%= doc.getEspecialidad() %></small>
        </div>
    </div>
    <%      } 
        } else { %>
        <p class="text-muted small">No hay doctores destacados.</p>
    <% } %>
</div>


            <!-- Widget: Acciones Rápidas -->
            <div class="sidebar-widget">
                <h5><i class="fas fa-bolt me-2"></i>Acciones Rápidas</h5>
                <a href="ServicioPaciente.jsp" class="btn w-100 mb-2" style="background-color: #0DDBA0; color: white;">
                    <i class="fas fa-calendar-plus me-2"></i>Agendar Cita
                </a>
                <a href="SvHistorial?tipo=citas" class="btn btn-outline-secondary w-100 mb-2">
                    <i class="fas fa-file-medical me-2"></i>Mis Citas
                </a>
                <a href="VideoConsultaPaciente.jsp" class="btn btn-outline-secondary w-100">
                    <i class="fas fa-video me-2"></i>VideoConsulta
                </a>
            </div>

            <!-- Widget: Consejos del Día -->
            <div class="sidebar-widget">
                <h5><i class="fas fa-lightbulb me-2"></i>Consejo del Día</h5>
                <p style="color: #555; font-size: 14px;">
                    💪 <strong>Ejercicio diario:</strong> Camina al menos 30 minutos al día para mantener tu corazón saludable y mejorar tu estado de ánimo.
                </p>
            </div>
        </div>
    </div>
</div>

<script>
    // Toggle reacciones
    function toggleReaction(postId, reactionType) {
        const btn = event.currentTarget;
        const icon = btn.querySelector('i');
        const countSpan = btn.querySelector('.reaction-count');
        let count = parseInt(countSpan.textContent);
        
        if (btn.classList.contains('active')) {
            btn.classList.remove('active');
            count--;
            icon.classList.remove('fas');
            icon.classList.add('far');
        } else {
            btn.classList.add('active');
            count++;
            icon.classList.remove('far');
            icon.classList.add('fas');
        }
        
        countSpan.textContent = count;
        
        // Aquí iría la llamada AJAX para guardar en base de datos
        console.log('Reacción:', reactionType, 'Post:', postId);
    }
    
    // Toggle comentarios
    function toggleComments(postId) {
        const commentsSection = document.getElementById('comments-' + postId);
        if (commentsSection.style.display === 'block') {
            commentsSection.style.display = 'none';
        } else {
            commentsSection.style.display = 'block';
        }
    }
    
    // Filtrar publicaciones por categoría
    function filterPosts(category) {
        const posts = document.querySelectorAll('.post-card');
        const pills = document.querySelectorAll('.filter-pill');
        
        // Actualizar pills activos
        pills.forEach(pill => pill.classList.remove('active'));
        event.currentTarget.classList.add('active');
        
        // Mostrar/ocultar publicaciones
        posts.forEach(post => {
            if (category === 'all') {
                post.style.display = 'block';
            } else {
                if (post.dataset.category === category) {
                    post.style.display = 'block';
                } else {
                    post.style.display = 'none';
                }
            }
        });
    }
    
    // Enviar comentario
    document.querySelectorAll('.comment-input-group button').forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.previousElementSibling;
            const commentText = input.value.trim();
            
            if (commentText) {
                console.log('Nuevo comentario:', commentText);
                // Aquí iría la llamada AJAX para guardar el comentario
                
                // Agregar comentario visual
                const commentsSection = this.closest('.comments-section');
                const newComment = document.createElement('div');
                newComment.className = 'comment';
                newComment.innerHTML = `
                    <div class="comment-avatar"><%= inicial %></div>
                    <div class="comment-content">
                        <p class="comment-author"><%= nombre %></p>
                        <p class="comment-text">${commentText}</p>
                    </div>
                `;
                commentsSection.insertBefore(newComment, this.parentElement);
                
                input.value = '';
                
                // Actualizar contador de comentarios
                const postCard = this.closest('.post-card');
                const commentBtn = postCard.querySelector('.post-footer button:last-child .reaction-count');
                commentBtn.textContent = parseInt(commentBtn.textContent) + 1;
            }
        });
    });
    
    // Enter para enviar comentario
    document.querySelectorAll('.comment-input-group input').forEach(input => {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.nextElementSibling.click();
            }
        });
    });
    //PLUGIN de USERWAY PARA ACCESIBILIDAD
    (function(d){
      var s = d.createElement("script");

      s.setAttribute("data-account", "vq320iVaXt");

      // Español
      s.setAttribute("data-language", "es");

      // Tamaño grande
      s.setAttribute("data-size", "large");

      // Encima de Bootstrap y otros elementos
      s.setAttribute("data-z-index", "999999");

      s.setAttribute("src", "https://cdn.userway.org/widget.js");

      (d.body || d.head).appendChild(s);
    })(document);


    
</script>
</body>
</html>
