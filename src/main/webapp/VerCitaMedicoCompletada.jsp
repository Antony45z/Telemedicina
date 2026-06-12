<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Citas Completadas - TELEMED</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/lucide@latest"></script>

<style>
:root {
  --color-principal: #0DDBA0;
  --color-hover: #0ab391;
}
body {
  padding-top: 80px;
  background: linear-gradient(135deg, #e6f9f6 0%, #d4f5f0 100%);
  min-height: 100vh;
}
.navbar-brand {
  font-weight: bold;
  color: var(--color-principal) !important;
}
.nav-link.active {
  color: var(--color-principal) !important;
  font-weight: bold;
}
.cita-card {
  background: white;
  border-radius: 14px;
  padding: 1.5rem;
  margin-bottom: 1.2rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  border-left: 5px solid var(--color-principal);
  transition: all 0.3s ease;
}
.cita-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.1);
}
.badge-codigo {
  background-color: #e6f9f6;
  color: var(--color-principal);
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.85rem;
}
.info-label {
  font-size: 0.75rem;
  color: #6c757d;
  font-weight: 600;
  text-transform: uppercase;
  margin-bottom: 0.25rem;
}
.info-value {
  font-size: 1rem;
  color: #212529;
  font-weight: 500;
}
.btn-diagnostico {
  background: linear-gradient(135deg, var(--color-principal) 0%, var(--color-hover) 100%);
  border: none;
  color: white;
  font-weight: 600;
  border-radius: 8px;
  padding: 0.6rem 1rem;
  transition: all 0.3s ease;
}
.btn-diagnostico:hover {
  box-shadow: 0 4px 12px rgba(13, 219, 160, 0.3);
  transform: translateY(-2px);
}
.modal-header {
  background: var(--color-principal);
  color: white;
  border-bottom: none;
}
.modal-footer .btn {
  font-weight: 600;
}
.diagnostico-box {
  background: #f8f9fa;
  border-left: 4px solid var(--color-principal);
  border-radius: 6px;
  padding: 0.75rem 1rem;
  margin-top: 0.75rem;
}
</style>
</head>

<%@ page session="true" %>
<%
  modelo.Medico medico = (modelo.Medico) session.getAttribute("medico");
  String nombreMedico = "Invitado";
  if (medico != null) nombreMedico = medico.getNombre() + " " + medico.getApellido();

  List<Map<String,Object>> citas = (List<Map<String,Object>>) request.getAttribute("citasCompletadas");
  SimpleDateFormat sdfFecha = new SimpleDateFormat("dd MMM yyyy");
  SimpleDateFormat sdfHora = new SimpleDateFormat("hh:mm a");
%>

<body>
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom:4px solid var(--color-principal);">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">TELEMED</a>
    <div class="collapse navbar-collapse" id="navbarDoctor">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <a class="nav-link" href="<%= request.getContextPath() %>/SvPublicacion">Inicio</a>
        <li class="nav-item"><a class="nav-link" href="SvCitasPendientesMedico">Citas Pendientes</a></li>
        <li class="nav-item"><a class="nav-link active" href="SvCitasCompletadasMedico">Citas Completadas</a></li>
        <li class="nav-item"><a class="nav-link" href="PerfilMedico.jsp">Perfil Médico</a></li>
        <li class="nav-item"><a class="nav-link" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
      </ul>
      <div class="dropdown">
        <button class="btn btn-light dropdown-toggle fw-bold" type="button" data-bs-toggle="dropdown">
          Dr. <%= nombreMedico %>
        </button>
        <ul class="dropdown-menu dropdown-menu-end">
          <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>

<div class="container mt-5 pt-4">
  <div class="header-card mb-4 bg-white p-4 rounded shadow-sm">
    <h2 class="mb-1" style="color:#212529;font-weight:700;">Citas Completadas</h2>
    <p class="text-muted mb-0">Revisa tus citas completadas e ingresa o edita diagnósticos</p>
    <div>
        <a href="SvReporteCitas?tipo=pdf" target="_blank" class="btn btn-danger btn-action">
            <i data-lucide="file-text"></i> PDF
        </a>
        
    </div>
  </div>

  <%
  if (citas != null && !citas.isEmpty()) {
      for (Map<String,Object> c : citas) {
          int idCita = (Integer)c.get("id_cita");
          String nombre = (String)c.get("nombre_paciente");
          String apellido = (String)c.get("apellido_paciente");
          java.util.Date fecha = (java.util.Date)c.get("fecha_cita");
          String motivo = (String)c.get("motivo");
          String ticket = (String)c.get("ticket");
          String diagnostico = (String)c.get("diagnostico");
          String receta = (String)c.get("receta");
          String tratamiento= (String)c.get("tratamiento");
          boolean tieneDiag = diagnostico != null && !diagnostico.trim().isEmpty();
  %>
  <div class="cita-card">
    <div class="row g-4 align-items-center">
      <div class="col-md-3">
        <h5 style="font-weight:600;">
          <i data-lucide="user"></i> <%= nombre + " " + apellido %>
        </h5>
        <div class="info-label">Fecha</div>
        <div class="info-value"><%= sdfFecha.format(fecha) %> - <%= sdfHora.format(fecha) %></div>
        <div class="badge-codigo mt-2"><i data-lucide="video"></i> <%= ticket %></div>
      </div>
      <div class="col-md-3">
        <div class="info-label">Motivo</div>
        <div class="info-value"><%= motivo %></div>
      </div>
      <div class="col-md-6 text-end">
        <% if (!tieneDiag) { %>
          <button class="btn-diagnostico" data-bs-toggle="modal" data-bs-target="#modalDiagnostico<%= idCita %>">
            <i data-lucide="file-plus"></i> Agregar diagnóstico
          </button>
        <% } else { %>
          <button class="btn btn-outline-success fw-semibold" data-bs-toggle="modal" data-bs-target="#modalDiagnostico<%= idCita %>">
            <i data-lucide="edit"></i> Editar diagnóstico
          </button>
          <div class="diagnostico-box text-start">
            <p class="mb-1"><strong>Diagnóstico:</strong> <%= diagnostico %></p>
            <% if (receta != null && !receta.isEmpty()) { %>
              <p class="mb-0"><strong>Receta:</strong> <%= receta %></p>
            <% } %>
            <p class="mb-0"><strong>Tratamiento:</strong> <%= (tratamiento != null) ? tratamiento : "----" %></p> <!--nuevo-->     
        
          </div>
        <% } %>
      </div>
    </div>
  </div>

  <!-- Modal para diagnóstico -->
  <div class="modal fade" id="modalDiagnostico<%= idCita %>" tabindex="-1" aria-labelledby="modalLabel<%= idCita %>" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <form action="SvRegistrarDiagnostico" method="post">
          <input type="hidden" name="idCita" value="<%= idCita %>">
          <input type="hidden" name="origen" value="normal">

          <div class="modal-header">
            <h5 class="modal-title" id="modalLabel<%= idCita %>">
              <%= tieneDiag ? "Editar diagnóstico de " + nombre + " " + apellido : "Nuevo diagnóstico para " + nombre + " " + apellido %>
            </h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label fw-semibold">Diagnóstico</label>
              <textarea name="descripcion" class="form-control" rows="3" required><%= tieneDiag ? diagnostico : "" %></textarea>
            </div>
            <div class="mb-3">
              <label class="form-label fw-semibold">Receta / Tratamiento</label>
              <textarea name="receta" class="form-control" rows="3"><%= tieneDiag ? receta : "" %></textarea>
            </div>
            <div class="mb-3">
              <label class="form-label fw-semibold">Tratamiento: </label>
              <textarea name="tratamiento" class="form-control" rows="3"><%= tieneDiag ? tratamiento : "" %></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            <button type="submit" class="btn btn-success" style="background-color: var(--color-principal); border: none;">
              <%= tieneDiag ? "Actualizar" : "Guardar" %> diagnóstico
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <%
      }
  } else {
  %>
  <div class="alert alert-info text-center">No tienes citas completadas registradas.</div>
  <%
  }
  %>

  <div class="mt-4">
    <a href="HomeMedico.jsp"
       class="btn w-100 py-3"
       style="background-color:#0ab391; border:none; color:white; font-weight:600; font-size:1rem;">
      <i data-lucide="arrow-left"></i> Volver al inicio
    </a>
  </div>
</div>

<script>
lucide.createIcons();
</script>
</body>
</html>
