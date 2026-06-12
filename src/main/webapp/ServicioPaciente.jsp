<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Medico"%>
<%@page import="dao.MedicoDAO"%>
<%@page import="dao.Conexion"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@page session="true"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Servicios - TELEMED</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .nav-link.active { color: var(--color-principal) !important; font-weight: bold; }
        .btn-primary { background-color: var(--color-principal); border: none; }
        .btn-primary:hover { background-color: #0ab391; }
        .card { border: 1px solid var(--color-principal); }
        .card-title { color: var(--color-principal); }
        body { padding-top: 80px; background-color: var(--color-secundario); }
    </style>
</head>
<body>

<%
    // Inicializar variables de conexión y DAO
    Connection con = null;
    MedicoDAO medicoDAO = null;
    List<Medico> medicos = null;
    List<String> especialidades = null;
    String filtroEsp = request.getParameter("especialidad");

    try {
        // Establecer la conexión
        con = Conexion.getConexion();
        medicoDAO = new MedicoDAO(con);

        // --- Lógica del Usuario y Sesión ---
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String rol = (String) session.getAttribute("rol");

        // VALIDAR SESIÓN
        if (usuario == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        // VALIDAR ROL
        if (rol == null || !rol.equalsIgnoreCase("PACIENTE")) {

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

        // --- Lógica de Filtrado y Listado de Médicos ---
        
        if (filtroEsp != null && !filtroEsp.trim().isEmpty()) {
            medicos = medicoDAO.filtrarMedicos(filtroEsp);
        } else {
            medicos = medicoDAO.listarMedicos();
        }
        
        especialidades = medicoDAO.listarEspecialidades();

// El bloque de cierre del try-catch estará después del HTML/JSP dinámico.
%>

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
                <li class="nav-item"><a class="nav-link active" href="ServicioPaciente.jsp">Servicios</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
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
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5 pt-4">

    <h3 class="mb-4">Elige un médico para agendar tu cita</h3>

    <form method="GET" action="ServicioPaciente.jsp" class="mb-4">
        <div class="input-group" style="max-width: 300px;">
            
            <select name="especialidad" class="form-select form-select-sm">
                <option value="">Todas las especialidades</option>

                <% 
                // Asegurar que la lista no es nula antes de iterar
                if (especialidades != null) { 
                    for (String esp : especialidades) {  
                        // Verificar el filtro actual y marcar como seleccionado
                        String selected = (filtroEsp != null && filtroEsp.equals(esp)) ? "selected" : "";
                %>
                        <option value="<%= esp %>" <%= selected %>><%= esp %></option>
                <%  }
                }
                %>
            </select>

            <button type="submit" class="btn btn-primary btn-sm">Filtrar</button>
        </div>
    </form>


    <div class="row">
        <% 
        if (medicos != null && !medicos.isEmpty()) {
            for (Medico m : medicos) {
                
                // 🛑 CORRECCIÓN CRÍTICA: Declarar la foto del médico DENTRO del bucle 
                // para que se actualice con cada iteración.
                byte[] fotoMedico = m.getFotoPerfil();
                String fotoMedicoBase64 = null;

                if (fotoMedico != null && fotoMedico.length > 0) {
                    fotoMedicoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(fotoMedico);
                }
        %>
            <div class="col-md-4 mb-3">
                <div class="card shadow-sm">
                    <div class="card-body text-center">
                        <% if (fotoMedicoBase64 != null) { %>
                            <img src="<%= fotoMedicoBase64 %>" 
                                 alt="<%= m.getNombre() %>"
                                 class="rounded mx-auto d-block mb-2"
                                 style="width:100px; height:100px; object-fit:cover; border-radius:50%;">
                        <% } else { %>
                            <div class="rounded-circle mx-auto d-flex align-items-center justify-content-center mb-2"
                                 style="width:100px; height:100px; background:#0DDBA0; color:white; font-weight:bold; font-size:32px;">
                                <%= m.getNombre().substring(0,1).toUpperCase() %>
                            </div>
                        <% } %>

                        <h5 class="card-title mt-3">
                            Dr(a). <%= m.getNombre() %> <%= m.getApellido() %>
                        </h5>
                        <p class="card-text">
                            <span class="fw-bold"><%= m.getEspecialidad() != null ? m.getEspecialidad() : "Sin especialidad" %></span><br>
                            <%= m.getCentroLaboral() != null ? m.getCentroLaboral() : "" %>
                        </p>
                        <a href="AgendarCitaPaciente.jsp?idMedico=<%= m.getIdMedico() %>" 
                           class="btn btn-primary w-100">Agendar Cita</a>
                    </div>
                </div>
            </div>
        <%     } // Fin del bucle for
        } else { %>
            <div class="col-12">
                <div class="alert alert-warning text-center">
                    No hay médicos registrados que cumplan con el criterio de búsqueda.
                </div>
            </div>
        <% } %>
        
    </div>
</div>

<%
    // Cierre del try-catch de la conexión
    } catch (SQLException e) {
        // En caso de error de conexión o base de datos
        e.printStackTrace();
%>
    <div class="container mt-5">
        <div class="alert alert-danger text-center">
            Error de conexión a la base de datos: <%= e.getMessage() %>
        </div>
    </div>
<%
    } finally {
        // Asegurarse de que la conexión se cierra
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignore) {}
        }
    }
%>

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