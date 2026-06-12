<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Medico, modelo.Diagnostico"%>
<%@ page session="true" %>

<%
    HttpSession sesion = request.getSession(false);

    // SIN SESIÓN
    if (sesion == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String rol = (String) sesion.getAttribute("rol");
    modelo.Medico medico =
        (modelo.Medico) sesion.getAttribute("medico");

    // SESIÓN EXISTE PERO NO ES MÉDICO
    if (rol == null || !"MEDICO".equalsIgnoreCase(rol) || medico == null) {
        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }

    // DATOS DEL MÉDICO
    String nombreMedico =
        medico.getNombre() + " " + medico.getApellido();
%>

<%
    // RECUPERACIÓN DE DATOS DE LA CITA
    String ticketSala = request.getParameter("ticket");
    if (ticketSala == null) ticketSala = "";

    Diagnostico diag = (Diagnostico) request.getAttribute("diagnostico");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>VideoConsulta - Médicos</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://meet.jit.si/external_api.js"></script>

    <style>
        :root { --color-principal: #0DDBA0; --color-secundario: #e6f9f6; }
        body { padding-top: 80px; background: linear-gradient(135deg, #e6f9f6 0%, #d4f5f0 100%); min-height: 100vh; }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .nav-link.active { color: var(--color-principal) !important; font-weight: bold; }
        .card-title { color: var(--color-principal); }
        .btn-primary { background-color: var(--color-principal); border: none; transition: all 0.3s ease; }
        .btn-primary:hover { background-color: #0ab391; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(13, 219, 160, 0.3); }
        .video-card { background: white; border-radius: 12px; padding: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        #meet { margin-top: 2rem; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.1); }
        .input-sala { border: 2px solid #e9ecef; border-radius: 8px; padding: 0.75rem 1rem; font-size: 1rem; transition: all 0.3s ease; }
        .input-sala:focus { border-color: var(--color-principal); box-shadow: 0 0 0 0.2rem rgba(13, 219, 160, 0.15); outline: none; }
        .btn-back { background-color: #6c757d; border: none; color: white; padding: 0.5rem 1.5rem; border-radius: 8px; transition: all 0.3s ease; text-decoration: none; display: inline-block; }
        .btn-back:hover { background-color: #5a6268; color: white; transform: translateY(-2px); }
    </style>
</head>
<body>

<% if("1".equals(request.getParameter("success"))) { %>
    <div class="alert alert-success mt-3 container">✅ Diagnóstico guardado correctamente</div>
<% } %>

<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
    <a class="navbar-brand" href="#">TELEMED</a>
    <div class="collapse navbar-collapse" id="navbarDoctor">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <a class="nav-link" href="<%= request.getContextPath() %>/SvPublicacion">Inicio</a>
        <li class="nav-item"><a class="nav-link" href="SvCitasPendientesMedico">Citas Pendientes</a></li>
        <li class="nav-item"><a class="nav-link " href="SvCitasCompletadasMedico">Citas Completadas</a></li>
        <li class="nav-item"><a class="nav-link" href="PerfilMedico.jsp">Perfil Médico</a></li>
        <li class="nav-item"><a class="nav-link active" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
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
    <div class="video-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="card-title mb-2">Consulta Médica</h3>
                <p class="text-muted mb-0">Atención al paciente vía videollamada</p>
            </div>
            <a href="SvCitasPendientesMedico" class="btn-back">← Volver</a>
        </div>

        <div class="mb-3">
            <label for="sala" class="form-label fw-bold">ID de la Sala:</label>
            <input type="text" id="sala" class="form-control input-sala" value="<%= ticketSala %>" readonly>
        </div>

        <button class="btn btn-primary w-100 py-3 fw-bold" onclick="iniciarLlamada()">🎥 Iniciar consulta</button>

        <div id="meet"></div>

        <hr class="my-4">
        
        <h4 class="card-title">Historia Clínica / Diagnóstico</h4>
        <form action="SvVideoConsulta" method="post" class="mt-3">
            <input type="hidden" name="ticket" value="<%= ticketSala %>">
            <input type="hidden" name="idCita" value="<%= request.getParameter("idCita") %>">
            <input type="hidden" name="origen" value="videoconsulta">

            <div class="mb-3">
                <label class="form-label fw-bold">Diagnóstico del paciente:</label>
                <textarea class="form-control" name="descripcion" rows="4" required placeholder="Escriba aquí el diagnóstico..."><%= (diag != null) ? diag.getDescripcion() : "" %></textarea>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Receta:</label>
                <textarea class="form-control" name="receta" rows="3" required placeholder="Medicamentos e indicaciones..."><%= (diag != null) ? diag.getReceta() : "" %></textarea>
            </div>
            
            <!--nuevo-->
            <div class="mb-3">
                <label class="form-label fw-bold">Tratamiento: </label>
                <textarea class="form-control" name="tratamiento" rows="5" required placeholder="Indicaciones para el uso de medicamentos..."><%= (diag != null) ? diag.getTratamiento() : "" %></textarea>
            </div>
            

            <button type="submit" class="btn btn-primary float-end">Guardar Historia Clínica</button>
            <div class="clearfix"></div>
        </form>
    </div>
</div>

<script>
    let api = null;

    function iniciarLlamada() {
        const roomName = document.getElementById("sala").value.trim();
        if (roomName === "") { 
            alert("Error: No hay un ticket de sala válido."); 
            return; 
        }

        if (api) { api.dispose(); }

        const domain = "meet.jit.si";
        const options = {
            roomName: roomName,
            width: "100%",
            height: 600,
            parentNode: document.querySelector('#meet'),
            userInfo: { 
                // AQUI ESTA LA CLAVE: Usamos el nombre real de la sesión
                displayName: "Dr. <%= nombreMedico %>" 
            },
            configOverwrite: { 
                startWithAudioMuted: false, 
                startWithVideoMuted: false,
                prejoinPageEnabled: false // Entrar directo sin pre-sala
            },
            interfaceConfigOverwrite: { 
                SHOW_JITSI_WATERMARK: false, 
                DEFAULT_BACKGROUND: '#0DDBA0',
                TOOLBAR_BUTTONS: [
                    'microphone', 'camera', 'desktop', 'fullscreen',
                    'fodeviceselection', 'hangup', 'profile', 'chat',
                    'settings', 'videoquality', 'filmstrip'
                ]
            }
        };

        api = new JitsiMeetExternalAPI(domain, options);
    }
</script>

</body>
</html>