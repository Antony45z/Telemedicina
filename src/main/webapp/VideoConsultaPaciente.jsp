<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario, java.util.Base64"%>
<%@ page session="true" %>
<%
    //  Verificar sesión activa
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String rol = (String) session.getAttribute("rol");
    if (rol == null || !"PACIENTE".equalsIgnoreCase(rol)) {
        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }
    //  Datos del usuario
    String nombre = usuario.getNombre() + " " + usuario.getApellido();
    String inicial = usuario.getNombre().substring(0, 1).toUpperCase();
    String fotoBase64 = null;

    byte[] foto = usuario.getFotoPerfil();
    if (foto != null && foto.length > 0) {
        fotoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(foto);
    }
%>
<%
    String idCitaStr = request.getParameter("idCita");
    String ticketCita = "";

    if (idCitaStr != null) {
        int idCita = Integer.parseInt(idCitaStr);

        // Obtener el ticket desde CitaDAO
        dao.CitaDAO citaDAO = new dao.CitaDAO();
        java.util.Map<String, Object> datosCita = citaDAO.obtenerCitaDetallada(idCita);

        if (datosCita != null) {
            ticketCita = (String) datosCita.get("ticket");
        }
    }
%>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Videoconsulta - TELEMED</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://meet.jit.si/external_api.js"></script>

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

        #meet {
            margin-top: 20px;
            border: 1px solid var(--color-principal);
            border-radius: 8px;
        }
    </style>
</head>
<body>

<!--  Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" 
     style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-uppercase" href="#" style="color: var(--color-principal);">
            TELEMED
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" 
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
      
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="SvPublicacionesPaciente">Inicio</a></li>
                <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=citas">Mis Citas</a></li>
        <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=diagnosticos">Mis Diagnósticos</a></li>
                <li class="nav-item"><a class="nav-link" href="ServicioPaciente.jsp">Servicios</a></li>
                <li class="nav-item"><a class="nav-link active" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (fotoBase64 != null) { %>
                    <img src="<%= fotoBase64 %>" alt="Perfil" 
                         class="rounded-circle me-2" width="40" height="40"
                         style="object-fit: cover;">
                <% } else { %>
                    <div class="rounded-circle d-flex align-items-center justify-content-center me-2"
                         style="width:40px; height:40px; background-color: var(--color-principal); 
                                color: white; font-weight:bold; font-size:18px;">
                        <%= inicial %>
                    </div>
                <% } %>

                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" 
                       id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
                        <span><%= nombre %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="dropdownUser">
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

<!-- Contenido principal -->
<div class="container mt-4">
    <div class="card shadow-sm p-4">
        <h3 class="card-title mb-4">Unirse a la Videoconsulta</h3>

        <div class="mb-3">
            <label for="sala" class="form-label">Ingresa el ID de la sala:</label>
            <input type="text" id="sala" class="form-control"
       value="<%= ticketCita %>"
       readonly>

        </div>

        <button class="btn btn-primary w-100" onclick="iniciarLlamada()">Unirse a la videollamada</button>

        <div id="meet"></div>
    </div>
</div>

<script>
    let api = null;

    function iniciarLlamada() {
        const roomName = document.getElementById("sala").value.trim();
        if (roomName === "") {
            alert("Por favor ingresa un ID de sala");
            return;
        }

        if (api) api.dispose();

        const domain = "meet.jit.si";
        const options = {
            roomName: roomName,
            width: "100%",
            height: 600,
            parentNode: document.querySelector('#meet'),
            userInfo: {
                displayName: "<%= nombre %>"
            }
        };
        api = new JitsiMeetExternalAPI(domain, options);
    }
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
