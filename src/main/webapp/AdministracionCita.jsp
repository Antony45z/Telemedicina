<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
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
  <title>Administración de Citas</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      background-color: #f8f9fa;
      padding-top: 80px;
    }
    main { flex: 1; }
    .navbar-custom { background-color: #0DDBA0; z-index: 1030; }
    footer { background-color: #0DDBA0; color: white; padding: 15px; text-align: center; }
    .btn-custom { background-color: #0DDBA0; color: white; border-radius: 30px; font-weight: bold; }
    .btn-custom:hover { background-color: #0bbd8a; }
    .card { border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,0.06); }
    table thead { background-color: #0DDBA0; color: white; }
    .table-hover tbody tr:hover { background-color: rgba(13,219,160,0.06); }
    .modal-header { background-color: #0DDBA0; color: white; border-bottom: none; }
    .btn-save { background-color: #0DDBA0; color: white; border: none; font-weight: 600; }
    .btn-save:hover { background-color: #0bbd8a; }
  </style>
</head>

<body>

  <!-- Navbar -->
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
            <a class="nav-link text-white fw-semibold " href="<%= request.getContextPath() %>/PublicacionServlet">Publicaciones</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold active" href="<%= request.getContextPath() %>/AdministracionCita">Citas</a>
          </li>
          
          <li class="nav-item">
            <a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/PaginaPrincipal.jsp">Cerrar sesión</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Contenido -->
  <main class="container my-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="fw-bold" style="color:#0DDBA0;">Administración de Citas</h2>
      
    </div>

    <div class="card p-3">
      <div class="table-responsive">
        <table class="table table-hover align-middle">
          <thead>
            <tr>
              <th>Ticket</th>
              <th>Paciente</th>
              <th>Médico</th>
              <th>Fecha</th>
              <th>Motivo</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
<%
    List<Map<String, Object>> citas = (List<Map<String, Object>>) request.getAttribute("citas");
    if (citas != null && !citas.isEmpty()) {
        for (Map<String, Object> c : citas) {
            int idCita = (int) c.get("id_cita");
            String ticket = (String) c.get("ticket");
            String paciente = (String) c.get("nombre_paciente");
            String medico = (String) c.get("nombre_medico");
            java.util.Date fecha = (java.util.Date) c.get("fecha_cita");
            String motivo = (String) c.get("motivo");
            String estado = (String) c.get("estado");
%>
<tr>
  <td><%= ticket %></td>
  <td><%= paciente %></td>
  <td><%= medico %></td>
  <td><%= new SimpleDateFormat("dd/MM/yyyy HH:mm").format(fecha) %></td>
  <td><%= motivo %></td>
  <td>
    <span class="badge <%= "Pendiente".equalsIgnoreCase(estado) ? "bg-warning" : 
                              "Completada".equalsIgnoreCase(estado) ? "bg-success" :
                              "Cancelada".equalsIgnoreCase(estado) ? "bg-danger" : "bg-secondary" %>">
      <%= estado %>
    </span>
  </td>
  <td>
    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editarCita<%= idCita %>">Editar</button>
    <a href="<%= request.getContextPath() %>/AdministracionCita?accion=eliminar&id=<%= idCita %>" 
       class="btn btn-sm btn-danger" 
       onclick="return confirm('¿Seguro que deseas eliminar la cita <%= ticket %>?');">
       Eliminar
    </a>
  </td>
</tr>

<!-- Modal de edición -->
<div class="modal fade" id="editarCita<%= idCita %>" tabindex="-1" aria-labelledby="modalLabel<%= idCita %>" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="SvActualizarEstadoCita" method="post">
        <input type="hidden" name="idCita" value="<%= idCita %>">
        <div class="modal-header">
          <h5 class="modal-title" id="modalLabel<%= idCita %>">Editar Estado de la Cita</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label fw-semibold">Estado actual:</label>
            <input type="text" class="form-control" value="<%= estado %>" readonly>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold">Nuevo Estado:</label>
            <select name="nuevoEstado" class="form-select" required>
              <option value="" disabled selected>Seleccione un estado</option>
              <option value="Pendiente">Pendiente</option>
              <option value="Completada">Completada</option>
              <option value="Cancelada">Cancelada</option>
              <option value="Reprogramada">Reprogramada</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
          <button type="submit" class="btn btn-save">Guardar Cambios</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%
        }
    } else {
%>
<tr>
  <td colspan="8" class="text-center text-muted">No hay citas registradas.</td>
</tr>
<%
    }
%>
</tbody>
        </table>
      </div>
    </div>
  </main>

  <footer>
    <p class="mb-0">© 2025 TeleMedicina Perú | Todos los derechos reservados</p>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
