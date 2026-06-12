<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario, modelo.Diagnostico, java.util.*, java.text.SimpleDateFormat, java.util.Base64"%>
<%@ page session="true" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    String rol = (String) session.getAttribute("rol");

    // VALIDAR SESIÓN
    if (usuario == null) {

        response.sendRedirect("login.jsp");
        return;
    }

    // VALIDAR ROL
    if (rol == null || !rol.equalsIgnoreCase("PACIENTE")) {

        response.sendRedirect("login.jsp");
        return;
    }

    String nombre = usuario.getNombre() + " " + usuario.getApellido();

    String inicial = usuario.getNombre()
                             .substring(0, 1)
                             .toUpperCase();
%>   

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Diagnósticos - TELEMED</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
        .table th {
            background-color: var(--color-principal) !important;
            color: white !important;
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
        .content {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
        }
        .table-hover tbody tr:hover {
            background-color: #f2fdf9;
        }
        .contador-card {
            background-color: #fff;
            border-left: 6px solid var(--color-principal);
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .contador-num {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--color-principal);
        }
        .titulo-verde {
            color: var(--color-principal);
            font-weight: bold;
        }
    </style>
</head>
<body>

<%
    String fotoBase64 = null;

    byte[] foto = usuario.getFotoPerfil();
    if (foto != null && foto.length > 0) {
        fotoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(foto);
    }

    List<Diagnostico> listaDiagnosticos = (List<Diagnostico>) request.getAttribute("listaDiagnosticos");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
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
                <li class="nav-item"><a class="nav-link active" href="SvHistorial?tipo=diagnosticos">Mis Diagnósticos</a></li>
                <li class="nav-item"><a class="nav-link" href="ServicioPaciente.jsp">Servicios</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (fotoBase64 != null) { %>
                    <img src="<%= fotoBase64 %>" alt="Perfil" class="rounded-circle me-2"
                         width="40" height="40" style="object-fit: cover;">
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
    <div class="mb-3 contador-card text-center mx-auto" style="max-width: 350px;">
        <div><strong>Total de diagnósticos registrados</strong></div>
        <div class="contador-num">
            <%= (listaDiagnosticos != null) ? listaDiagnosticos.size() : 0 %>
        </div>
    </div>

    <div class="content shadow-sm">
        <h3 class="mb-4 text-center titulo-verde">Mis Diagnósticos</h3>

        <% if (listaDiagnosticos != null && !listaDiagnosticos.isEmpty()) { %>
            <table class="table table-hover table-bordered">
                <thead class="table-success text-center">
                    <tr>
                        <th>#</th>
                        <th>Fecha</th>
                        <th>Descripción</th>
                        <th>Receta</th>
                        <th>Tratamiento</th> <!--nuevo-->
                    </tr>
                </thead>
                <tbody class="text-center">
                    <% int i = 1;
                       for (Diagnostico d : listaDiagnosticos) { %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><%= sdf.format(d.getFechaRegistro()) %></td>
                            <td><%= d.getDescripcion() %></td>
                            <td><%= (d.getReceta() != null && !d.getReceta().isEmpty()) ? d.getReceta() : "-" %></td>
                            <td><%= (d.getTratamiento() != null) ? d.getTratamiento() : "---" %></td> <!--nuevo-->
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="alert alert-info text-center">
                No tienes diagnósticos registrados por el momento.
            </div>
        <% } %>
    </div>
</div>
    <script>
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