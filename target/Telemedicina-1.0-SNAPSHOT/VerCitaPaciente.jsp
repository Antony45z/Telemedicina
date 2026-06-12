<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Usuario, modelo.Cita, java.util.*, java.text.SimpleDateFormat, java.util.Base64"%>
<%@page import="java.util.Date"%>
<%@ page session="true" %>

<%
    String rol = (String) session.getAttribute("rol");

    if (rol == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"PACIENTE".equalsIgnoreCase(rol)) {
        response.sendRedirect("AccesoDenegado.jsp");
        return;
    }

    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String nombre = usuario.getNombre() + " " + usuario.getApellido();
    String inicial = usuario.getNombre().substring(0, 1).toUpperCase();
    String fotoBase64 = null;

    byte[] foto = usuario.getFotoPerfil();
    if (foto != null && foto.length > 0) {
        fotoBase64 = "data:image/png;base64," + Base64.getEncoder().encodeToString(foto);
    }

    List<Cita> listaCitas = (List<Cita>) request.getAttribute("listaCitas");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Citas - TELEMED</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>

    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
        body { padding-top: 80px; background-color: var(--color-secundario); }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .nav-link.active { color: var(--color-principal) !important; font-weight: bold; }
        .content {
            background: #fff; border-radius: 10px; padding: 30px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .contador-card {
            background: #fff; border: 2px solid var(--color-principal);
            border-radius: 12px; padding: 15px; text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .contador-num { color: var(--color-principal); font-size: 2.5rem; font-weight: bold; }
        .table th { background-color: var(--color-principal); color: white; }
        .table-hover tbody tr:hover { background-color: #f2fdf9; }
        .titulo-verde { color: var(--color-principal); font-weight: bold; }
        .btn-action.btn-details { background-color: #f8f9fa; color: #495057; }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-uppercase" href="#">TELEMED</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="SvPublicacionesPaciente">Inicio</a></li>
                <li class="nav-item"><a class="nav-link active" href="SvHistorial?tipo=citas">Mis Citas</a></li>
                <li class="nav-item"><a class="nav-link" href="SvHistorial?tipo=diagnosticos">Mis Diagnósticos</a></li>
                <li class="nav-item"><a class="nav-link" href="ServicioPaciente.jsp">Servicios</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaPaciente.jsp">VideoConsulta</a></li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (fotoBase64 != null) { %>
                    <img src="<%= fotoBase64 %>" class="rounded-circle me-2" width="40" height="40" style="object-fit: cover;">
                <% } else { %>
                    <div class="rounded-circle d-flex align-items-center justify-content-center me-2"
                         style="width:40px; height:40px; background-color: var(--color-principal); color:white; font-weight:bold;">
                        <%= inicial %>
                    </div>
                <% } %>

                <div class="dropdown">
                    <a href="#" class="dropdown-toggle" id="dropdownUser" data-bs-toggle="dropdown">
                        <span><%= nombre %></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><a class="dropdown-item" href="PerfilPaciente.jsp">Mi Perfil</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>

<!-- CONTENIDO -->
<div class="container mt-4">
    <div class="mb-3 contador-card text-center mx-auto" style="max-width: 350px;">
        <div>Total de citas registradas</div>
        <div class="contador-num"><%= (listaCitas != null) ? listaCitas.size() : 0 %></div>
    </div>

            <div     class="content shadow-sm">
                <h3 class="mb-4 text-center titulo-verde">Mis Citas Médicas</h3>
                <div class="alert alert-info text-center">
            Las citas en estado <strong>Pendiente</strong> solo pueden <strong>reprogramarse</strong> o <strong>cancelarse</strong> 
            si faltan al menos <strong>24 horas</strong> para la fecha y hora programada.
        </div>
        <% if (listaCitas != null && !listaCitas.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover table-bordered align-middle text-center">
                    <thead class="table-success text-center">
<tr>
    <th>#</th>
    <th>Fecha y Hora</th>
    <th>Motivo</th>
    <th>Doctor</th>
    <th>Especialidad</th>
    <th>Estado</th>
    <th>Diagnóstico</th>
    <th>Ticket</th>
    <th>Videoconsulta</th>
    <th>Acciones</th> 
</tr>
</thead>


                    <tbody>
                    <% int i = 1;
                       for (Cita c : listaCitas) { %>
                       <tr>
    <td><%= i++ %></td>
    <td><%= sdf.format(c.getFechaCita()) %></td>
    <td><%= c.getMotivo() %></td>
    <td><%= c.getNombreMedico() %></td>
    <td><%= c.getEspecialidadMedico() %></td>

    <td>
        <span class="badge 
            <%= "Completada".equalsIgnoreCase(c.getEstado()) ? "bg-success" :
                "Cancelada".equalsIgnoreCase(c.getEstado()) ? "bg-danger" :
                "Pendiente".equalsIgnoreCase(c.getEstado()) ? "bg-warning text-dark" : "bg-secondary" %>">
            <%= c.getEstado() %>
        </span>
    </td>

    <!-- Botón diagnóstico -->
    <td>
        <% if (c.getDescripcionDiagnostico() != null) { %>
            <button class="btn btn-success btn-sm"
                    data-bs-toggle="modal"
                    data-bs-target="#modalDiag<%= c.getIdCita() %>">
                <i data-lucide="book-open"></i> Diagnóstico
            </button>
        <% } else { %>
            -
        <% } %>
    </td>

    <td><%= c.getTicket() %></td>

    <!-- BOTÓN VIDEOCONSULTA -->
    <td>
        <% if ("Pendiente".equalsIgnoreCase(c.getEstado())) { %>

            <a href="VideoConsultaPaciente.jsp?idCita=<%= c.getIdCita() %>"
               class="btn btn-primary btn-sm">
                <i data-lucide="video"></i> Unirse a Videoconsulta
               
            </a>

        <% } else { %>
            -
        <% } %>
    </td>
    <td>
        <%
            long ahora = System.currentTimeMillis();

            long diferenciaMs =
                c.getFechaCita().getTime() - ahora;

            // Más de 24 horas antes
            boolean antesDe24Horas =
                diferenciaMs >= (24L * 60 * 60 * 1000);

            // Pasaron más de 30 minutos después de la cita
            boolean paso30Min =
                diferenciaMs <= -(30L * 60 * 1000);

            boolean puedeReprogramar =
                "Pendiente".equalsIgnoreCase(c.getEstado())
                &&
                (
                    antesDe24Horas
                    ||
                    paso30Min
                );
        %>
        <!-- INFORMACIÓN -->
        <button
        class="btn btn-action btn-details"

        data-bs-toggle="modal"
        data-bs-target="#modalInfo"

        data-id="<%= c.getIdCita() %>"
        data-medico="<%= c.getIdMedico() %>"
        data-doctor="<%= c.getNombreMedico() %>"
        data-especialidad="<%= c.getEspecialidadMedico() %>"
        data-fecha="<%= sdf.format(c.getFechaCita()) %>"
        data-estado="<%= c.getEstado() %>">

        <i data-lucide="play"></i>

    </button>
        
    </td>
</tr>

                        
                    <% } %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="alert alert-info text-center mt-4">
                No tienes citas registradas por el momento.
            </div>
        <% } %>
    </div>
</div>

<!-- MODALES DE DIAGNÓSTICO -->
<% if (listaCitas != null) {
       for (Cita c : listaCitas) {
           if (c.getDescripcionDiagnostico() != null) { %>

<div class="modal fade" id="modalDiag<%= c.getIdCita() %>" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header bg-success text-white">
                <h5 class="modal-title">Diagnóstico de la Cita</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <h6><strong>Descripción:</strong></h6>
                <p><%= c.getDescripcionDiagnostico() %></p>

                <h6><strong>Receta:</strong></h6>
                <p><%= (c.getRecetaDiagnostico() != null) ? c.getRecetaDiagnostico() : "Sin receta" %></p>
                
                <h6><strong>Tratamiento:</strong></h6>
                <p><%= (c.getTratamiento() != null) ? c.getTratamiento() : "Sin tratamiento" %></p>  <!--nuevo-->
                
                
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>

        </div>
    </div>
</div>
           
           
           
<%   } 
     }
   } %>
<!-- MODAL REPROGRAMAR -->
<div class="modal fade"
     id="modalReprogramar"
     tabindex="-1">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content">

            <form action="SvReprogramarCita"
                  method="post">

                <div class="modal-header bg-warning">

                    <h5 class="modal-title fw-bold">
                        Reprogramar Cita
                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body">

                    <!-- ID -->
                    <input type="hidden"
                           name="idCita"
                           id="idCitaModal">

                    <!-- INFO -->
                    <div class="alert alert-secondary">

                        <h6 class="fw-bold mb-3">
                            Información actual
                        </h6>

                        <p class="mb-1">
                            <strong>Doctor:</strong>
                            <span id="doctorModal"></span>
                        </p>

                        <p class="mb-1">
                            <strong>Especialidad:</strong>
                            <span id="especialidadModal"></span>
                        </p>

                        <p class="mb-0">
                            <strong>Fecha actual:</strong>
                            <span id="fechaActualModal"></span>
                        </p>

                    </div>

                    <!-- FECHA -->
                    <div class="mb-3">

                        <label class="form-label fw-bold">
                            Nueva fecha
                        </label>

                        <input type="date"
                               class="form-control"
                               id="fechaModal"
                               name="fecha"
                               required>

                    </div>

                    <!-- HORA -->
                    <div class="mb-3">

                        <label class="form-label fw-bold">
                            Nueva hora
                        </label>

                        <select name="hora"
                                id="horaModal"
                                class="form-select"
                                required>

                            <option value="">
                                Seleccione fecha primero
                            </option>

                        </select>

                    </div>
                    <!-- MOTIVO -->
                    <div class="mb-3">

                        <label class="form-label fw-bold">
                            Motivo de reprogramación
                        </label>

                        <textarea
                            name="motivoReprogramacion"
                            class="form-control"
                            rows="3"
                            placeholder="Explique el motivo..."
                            required></textarea>

                    </div>

                    <div class="alert alert-info mt-3">

                        Solo puede reprogramar citas pendientes
                        con más de 24 horas de anticipación.

                    </div>

                </div>

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">

                        Cancelar

                    </button>

                    <button class="btn btn-success"
                            type="submit">

                        Guardar cambios

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
<div class="modal fade"
     id="modalCancelar"
     tabindex="-1">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content">

            <form action="SvCancelarCita"
                  method="post">

                <div class="modal-header bg-danger text-white">

                    <h5 class="modal-title">
                        Cancelar Cita
                    </h5>

                    <button type="button"
                            class="btn-close btn-close-white"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body">

                    <input type="hidden"
                           name="idCita"
                           id="idCitaCancelar">

                    <div class="mb-3">

                        <label class="form-label fw-bold">
                            Motivo de cancelación
                        </label>

                        <textarea
                            name="motivo"
                            class="form-control"
                            rows="4"
                            placeholder="Opcional..."></textarea>

                    </div>

                    <div class="alert alert-warning">
                        Esta acción cambiará el estado de la cita a cancelada.
                    </div>

                </div>

                <div class="modal-footer">

                    <button type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">

                        Cerrar

                    </button>

                    <button type="submit"
                            class="btn btn-danger">

                        Confirmar cancelación

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
<!-- MODAL INFORMACIÓN -->
<div class="modal fade"
     id="modalInfo"
     tabindex="-1"
     aria-hidden="true">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content border-0 shadow">

            <div class="modal-header bg-info text-white">

                <h5 class="modal-title fw-bold">
                    Información de la Cita
                </h5>

                <button type="button"
                        class="btn-close btn-close-white"
                        data-bs-dismiss="modal">
                </button>

            </div>

            <div class="modal-body bg-light">

                <div id="contenidoInfoCita">

                    <div class="text-center py-5">

                        <div class="spinner-border text-info"></div>

                        <p class="mt-3 mb-0 fw-semibold text-secondary">
                            Cargando historial de la cita...
                        </p>

                    </div>

                </div>

            </div>

            <div class="modal-footer">

                <button
                    type="button"
                    class="btn btn-warning"
                    id="btnAbrirReprogramar">

                    Reprogramar Cita

                </button>

                <button
                    type="button"
                    class="btn btn-danger"
                    id="btnAbrirCancelar">

                    Cancelar Cita

                </button>

                <button
                    type="button"
                    class="btn btn-secondary"
                    data-bs-dismiss="modal">

                    Cerrar

                </button>

            </div>

        </div>

    </div>

</div>
<script>
lucide.createIcons();
const modal =
    document.getElementById(
        'modalReprogramar'
    );

let idMedicoActual = 0;

// CUANDO SE ABRE EL MODAL
modal.addEventListener(
    'show.bs.modal',
    function(event){

        const button =
            event.relatedTarget;

        // DATOS
        const idCita =
            button.getAttribute('data-id');

        const idMedico =
            button.getAttribute('data-medico');

        const doctor =
            button.getAttribute('data-doctor');

        const especialidad =
            button.getAttribute('data-especialidad');

        const fechaActual =
            button.getAttribute('data-fecha');

        // GUARDAR ID MÉDICO
        idMedicoActual = idMedico;

        // CARGAR DATOS EN MODAL
        document.getElementById(
            'idCitaModal'
        ).value = idCita;

        document.getElementById(
            'doctorModal'
        ).innerText = doctor;

        document.getElementById(
            'especialidadModal'
        ).innerText = especialidad;

        document.getElementById(
            'fechaActualModal'
        ).innerText = fechaActual;

        // LIMPIAR HORAS
        document.getElementById(
            'horaModal'
        ).innerHTML =
        '<option value="">Seleccione fecha primero</option>';

        // LIMPIAR FECHA
        document.getElementById(
            'fechaModal'
        ).value = '';
    }
);

// CUANDO CAMBIA FECHA
document.getElementById(
    'fechaModal'
).addEventListener(
    'change',
    function(){

        const fecha = this.value;

        fetch(
            '<%= request.getContextPath() %>/SvReprogramarCita?idMedico='
            + idMedicoActual
            + '&fecha='
            + fecha
        )

        .then(response => response.json())

        .then(horas => {

            console.log(horas);

            const combo =
                document.getElementById(
                    'horaModal'
                );

            combo.innerHTML = '';

            if(horas.length === 0){

                combo.innerHTML =
                    '<option value="">No hay horarios disponibles</option>';

                return;
            }

            combo.innerHTML = "";

            const primera =
                document.createElement("option");

            primera.value = "";
            primera.textContent =
                "Seleccione una hora";

            combo.appendChild(primera);

            horas.forEach(hora => {

                const option =
                    document.createElement("option");

                option.value = hora;
                option.textContent = hora;

                combo.appendChild(option);
            });
        })

        .catch(error => {

            console.log("ERROR:");
            console.log(error);
        });
    }
);
const modalCancelar =
    document.getElementById('modalCancelar');

modalCancelar.addEventListener(
    'show.bs.modal',
    function(event){

        const button = event.relatedTarget;

        const idCita =
            button.getAttribute('data-id');

        document.getElementById(
            'idCitaCancelar'
        ).value = idCita;
    }
);
const modalInfo =
    document.getElementById(
        'modalInfo'
    );

modalInfo.addEventListener(
    'show.bs.modal',
    function(event){

        const button =
            event.relatedTarget;

        const idCita =
            button.getAttribute(
                'data-id'
            );
        const idMedico =
            button.getAttribute('data-medico');

        const doctor =
            button.getAttribute('data-doctor');

        const especialidad =
            button.getAttribute('data-especialidad');

        const fecha =
            button.getAttribute('data-fecha');

        const estado =
            button.getAttribute('data-estado');

        // GUARDAR BOTONES
        document.getElementById(
            'btnAbrirReprogramar'
        ).dataset.idCita = idCita;

        document.getElementById(
            'btnAbrirReprogramar'
        ).dataset.idMedico = idMedico;

        document.getElementById(
            'btnAbrirReprogramar'
        ).dataset.doctor = doctor;

        document.getElementById(
            'btnAbrirReprogramar'
        ).dataset.especialidad = especialidad;

        document.getElementById(
            'btnAbrirReprogramar'
        ).dataset.fecha = fecha;

        document.getElementById(
            'btnAbrirCancelar'
        ).dataset.idCita = idCita;

        // VALIDAR SI SE PUEDE
        const fechaCita = new Date(fecha.replace(" ", "T"));

        const diferenciaMs =
            fechaCita.getTime()
            - Date.now();

        const puedeModificar =
            estado.toLowerCase() === 'pendiente'
            &&
            (
                diferenciaMs >= (24 * 60 * 60 * 1000)
                ||
                diferenciaMs <= -(30 * 60 * 1000)
            );

        document.getElementById(
            'btnAbrirReprogramar'
        ).disabled = !puedeModificar;

        document.getElementById(
            'btnAbrirCancelar'
        ).disabled = !puedeModificar;
        const contenedor =
            document.getElementById(
                'contenidoInfoCita'
            );

        contenedor.innerHTML = `
            <div class="text-center py-5">

                <div class="spinner-border text-info">
                </div>

                <p class="mt-3 mb-0 fw-semibold text-secondary">
                    Cargando historial de la cita...
                </p>

            </div>
        `;

        fetch(
            '<%= request.getContextPath() %>/SvInfoCita?idCita='
            + idCita
        )

        .then(response => response.text())

        .then(html => {

            contenedor.innerHTML =
                html;

        })

        .catch(error => {

            console.log(error);

            contenedor.innerHTML = `
                <div class="alert alert-danger">
                    Error al cargar la información.
                </div>
            `;

        });
    }
);
document.getElementById(
    'btnAbrirReprogramar'
).addEventListener(
    'click',
    function(){

        document.getElementById(
            'idCitaModal'
        ).value =
            this.dataset.idCita;

        idMedicoActual =
            this.dataset.idMedico;

        document.getElementById(
            'doctorModal'
        ).innerText =
            this.dataset.doctor;

        document.getElementById(
            'especialidadModal'
        ).innerText =
            this.dataset.especialidad;

        document.getElementById(
            'fechaActualModal'
        ).innerText =
            this.dataset.fecha;

        bootstrap.Modal
            .getInstance(
                document.getElementById(
                    'modalInfo'
                )
            )
            .hide();

        new bootstrap.Modal(
            document.getElementById(
                'modalReprogramar'
            )
        ).show();
    }
);

document.getElementById(
    'btnAbrirCancelar'
).addEventListener(
    'click',
    function(){

        document.getElementById(
            'idCitaCancelar'
        ).value =
            this.dataset.idCita;

        bootstrap.Modal
            .getInstance(
                document.getElementById(
                    'modalInfo'
                )
            )
            .hide();

        new bootstrap.Modal(
            document.getElementById(
                'modalCancelar'
            )
        ).show();
    }
);
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
