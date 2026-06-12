<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="modelo.Publicacion"%>
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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrar Publicaciones</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background: #f4f6f9; padding-top: 80px; }
        .navbar-custom { background-color: #0DDBA0; }
        .table thead { background: #0DDBA0; color: white; }
        .btn-custom { background-color: #0DDBA0; color: white; border-radius: 20px; }
        .btn-custom:hover { background-color: #0bbd8a; }
    </style>
</head>
<body>

<!-- NAVBAR -->
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
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionMedico">Médicos</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionPaciente">Pacientes</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold active" href="<%= request.getContextPath() %>/PublicacionServlet">Publicaciones</a>
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

<div class="container mt-4">

    <h2 class="mb-3 text-center">Gestión de Publicaciones</h2>

    <!-- BOTÓN AGREGAR -->
    <div class="d-flex justify-content-end mb-3">
        <button class="btn btn-custom" data-bs-toggle="modal" data-bs-target="#modalPublicacion"
                onclick="limpiarFormulario();">
            + Nueva Publicación
        </button>
    </div>

    <!-- TABLA -->
    <div class="card p-3 shadow-sm">
        <table class="table table-hover text-center">
            <thead>
                <tr>
                    <th>Título</th>
                    <th>Contenido</th>
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>

                <%
                    List<Publicacion> lista = (List<Publicacion>) request.getAttribute("publicaciones");

                    if (lista != null) {
                        for (Publicacion p : lista) {
                %>

                <tr>
                    <td><%= p.getTitulo() %></td>
                    <td><%= p.getContenido().substring(0, Math.min(40, p.getContenido().length())) %>...</td>
                    <td><%= p.getFechaPublicacion() %></td>

                    <td>
                        <button 
                            class="btn btn-warning btn-sm"
                            data-id="<%= p.getIdPublicacion() %>"
                            data-medico="<%= p.getIdMedico() %>"
                            data-categoria="<%= p.getIdCategoria() %>"
                            data-titulo="<%= p.getTitulo() %>"
                            data-contenido="<%= p.getContenido() %>"
                            onclick="editarDesdeData(this)"
                            data-bs-toggle="modal" data-bs-target="#modalPublicacion">
                            Editar
                        </button>

                        <a href="PublicacionServlet?accion=eliminar&id=<%= p.getIdPublicacion() %>"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('¿Eliminar publicación?');">
                            Eliminar
                        </a>
                    </td>
                </tr>

                <% 
                        }
                    }
                %>

            </tbody>
        </table>
    </div>
</div>


<!-- MODAL REGISTRAR / EDITAR -->
<div class="modal fade" id="modalPublicacion" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <form action="PublicacionServlet" method="post">

                <div class="modal-header" style="background:#0DDBA0;">
                    <h5 class="modal-title text-white">Publicación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <input type="hidden" name="accion" id="accion" value="registrar">
                    <input type="hidden" name="idPublicacion" id="idPublicacion">

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label>Médico</label>
                            <input type="number" class="form-control" name="idMedico" id="idMedico" required>
                        </div>

                        <div class="col-md-6">
                            <label>Categoría</label>
                            <input type="number" class="form-control" name="idCategoria" id="idCategoria">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label>Título</label>
                        <input type="text" class="form-control" name="titulo" id="titulo" required>
                    </div>

                    <div class="mb-3">
                        <label>Contenido</label>
                        <textarea class="form-control" name="contenido" id="contenido"
                                  rows="6" required></textarea>
                    </div>

                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-custom">Guardar</button>
                </div>

            </form>

        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function limpiarFormulario() {
        document.getElementById("accion").value = "registrar";
        document.getElementById("idPublicacion").value = "";
        document.getElementById("idMedico").value = "";
        document.getElementById("idCategoria").value = "";
        document.getElementById("titulo").value = "";
        document.getElementById("contenido").value = "";
    }

    function editarDesdeData(btn) {
        document.getElementById("accion").value = "editar";
        document.getElementById("idPublicacion").value = btn.dataset.id;
        document.getElementById("idMedico").value = btn.dataset.medico;
        document.getElementById("idCategoria").value = btn.dataset.categoria;
        document.getElementById("titulo").value = btn.dataset.titulo;
        document.getElementById("contenido").value = btn.dataset.contenido;
    }
</script>

</body>
</html>
