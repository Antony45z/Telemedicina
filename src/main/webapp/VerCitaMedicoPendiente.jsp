<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citas Pendientes - TELEMED</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
            --color-hover: #0ab391;
            --color-warning: #ffc107;
            --color-info: #17a2b8;
        }
        body { 
            padding-top: 80px; 
            background: linear-gradient(135deg, #e6f9f6 0%, #d4f5f0 100%);
            min-height: 100vh;
        }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .nav-link.active { color: var(--color-principal) !important; font-weight: bold; }
        .btn-primary { background-color: var(--color-principal); border: none; transition: all 0.3s ease; }
        .btn-primary:hover { background-color: var(--color-hover); transform: translateY(-2px); box-shadow: 0 4px 8px rgba(13, 219, 160, 0.3); }
        .cita-card { background: white; border-radius: 12px; padding: 1.5rem; margin-bottom: 1rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: all 0.3s ease; border-left: 4px solid var(--color-principal); position: relative; overflow: hidden; }
        .cita-pendiente {
            border-left: 4px solid #198754;
        }

        .cita-cancelada {
            border-left: 4px solid #dc3545;
        }

        .cita-completada {
            border-left: 4px solid #0d6efd;
        }

        .badge-estado {
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .badge-pendiente {
            background-color: #d1e7dd;
            color: #0f5132;
        }

        .badge-cancelada {
            background-color: #f8d7da;
            color: #842029;
        }

        .badge-completada {
            background-color: #cfe2ff;
            color: #084298;
        }
        .cita-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.12); transform: translateY(-4px); }
        .header-card { background: white; border-radius: 12px; padding: 2rem; margin-bottom: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .badge-codigo { background-color: #e6f9f6; color: var(--color-principal); padding: 0.5rem 1rem; border-radius: 20px; font-weight: 600; font-size: 0.85rem; display: inline-flex; align-items: center; gap: 0.5rem; }
        .info-label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.5px; color: #6c757d; font-weight: 600; margin-bottom: 0.25rem; }
        .info-value { font-size: 1rem; color: #212529; font-weight: 500; }
        .icon-wrapper { width: 48px; height: 48px; background: linear-gradient(135deg, var(--color-principal) 0%, #0ab391 100%); border-radius: 12px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(13, 219, 160, 0.2); }
        .time-badge { background-color: #f8f9fa; padding: 0.5rem 1rem; border-radius: 8px; display: inline-flex; align-items: center; gap: 0.5rem; font-weight: 500; }
        .btn-action { padding: 0.5rem 1.25rem; border-radius: 8px; font-weight: 600; font-size: 0.9rem; transition: all 0.3s ease; border: none; display: inline-flex; align-items: center; justify-content: center; gap: 0.5rem; }
        .btn-action.btn-join { background: linear-gradient(135deg, var(--color-principal) 0%, #0ab391 100%); color: white; text-decoration: none; }
        .btn-action.btn-join:hover { transform: translateX(4px); box-shadow: 0 4px 12px rgba(13, 219, 160, 0.3); color: white; }
        .btn-action.btn-details { background-color: #f8f9fa; color: #495057; }
        .btn-action.btn-details:hover { background-color: #e9ecef; }
    </style>
</head>

<%@ page session="true" %>
<%
    modelo.Medico medico = (modelo.Medico) session.getAttribute("medico");
    String nombreMedico = "Invitado";
    if (medico != null) {
        nombreMedico = medico.getNombre() + " " + medico.getApellido();
    }
%>

<body>
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">TELEMED</a>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse"
                data-bs-target="#navbarDoctor">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarDoctor">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <a class="nav-link" href="<%= request.getContextPath() %>/SvPublicacion">Inicio</a>
                <li class="nav-item"><a class="nav-link active" href="SvCitasPendientesMedico">Citas Pendientes</a></li>
                <li class="nav-item"><a class="nav-link" href="SvCitasCompletadasMedico">Citas Completadas</a></li>
                <li class="nav-item"><a class="nav-link" href="PerfilMedico.jsp">Perfil Médico</a></li>
                <li class="nav-item"><a class="nav-link" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
            </ul>
            <div class="dropdown">
                <button class="btn btn-light dropdown-toggle fw-bold" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                    Dr. <%= nombreMedico %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                    <li><a class="dropdown-item text-danger" href="SvLogout">Cerrar Sesión</a></li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5 pt-4">
    <div class="header-card mb-4 d-flex justify-content align-items-center">
    <div>
        <h2 class="mb-1" style="color: #212529; font-weight: 700;">Citas Pendientes</h2>
        <p class="text-muted mb-0">Gestiona tus consultas programadas</p>
<div class="alert alert-info text-center mt-3 mx-auto"
     style="max-width: 850px;">Las citas en estado <strong>Pendiente</strong> solo pueden <strong>reprogramarse</strong> o <strong>cancelarse</strong> 
            si faltan al menos <strong>24 horas</strong> para la fecha y hora programada.
        </div>
    </div>
    
</div>
    
    <!-- 📋 Citas dinámicas -->
    <div id="citasContainer">
   <%
    List<Map<String, Object>> citas = (List<Map<String, Object>>) request.getAttribute("citasPendientes");
    SimpleDateFormat sdfFecha = new SimpleDateFormat("dd MMM yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat sdfIso =
    new SimpleDateFormat("yyyy-MM-dd HH:mm");
    if (citas != null && !citas.isEmpty()) {
        for (Map<String, Object> c : citas) {
            
            // Línea corregida para manejar valores NULL de forma segura
            Integer idPacienteObj = (Integer) c.get("id_paciente");
            int id_Paciente = (idPacienteObj != null) ? idPacienteObj.intValue() : 0; // Si es null, usa 0
            
            String nombre = (String) c.get("nombre_paciente");
            String apellido = (String) c.get("apellido_paciente");
            // Asegúrate de que la fecha es un tipo compatible (java.util.Date o java.sql.Timestamp)
            Object fechaObj = c.get("fecha_cita");
            java.util.Date fecha = (fechaObj instanceof java.util.Date) ? (java.util.Date) fechaObj : new java.util.Date(); 
            
            String motivo = (String) c.get("motivo");
            String ticket = (String) c.get("ticket");
            
            // Manejo de idCita (asumiendo que es int)
            Integer idCitaObj = (Integer) c.get("id_cita");
            int idCita = (idCitaObj != null) ? idCitaObj.intValue() : 0;
            long ahora = System.currentTimeMillis();

            long fechaCita = fecha.getTime();

            String estado = (String) c.get("estado");
            String claseCard = "";
            String claseBadge = "";

            if("Pendiente".equalsIgnoreCase(estado)){
                claseCard = "cita-pendiente";
                claseBadge = "badge-pendiente";
            }
            else if("Cancelada".equalsIgnoreCase(estado)){
                claseCard = "cita-cancelada";
                claseBadge = "badge-cancelada";
            }
            else if("Completada".equalsIgnoreCase(estado)){
                claseCard = "cita-completada";
                claseBadge = "badge-completada";
            }
            boolean puedeModificar =
                "Pendiente".equalsIgnoreCase(estado)
                &&
                (
                    (fechaCita - ahora) >
                    (24L * 60 * 60 * 1000)
                    ||
                    (ahora - fechaCita) >
                    (30L * 60 * 1000)
                );
%>
    
<div class="cita-card <%= claseCard %>">
    <div class="row g-4 align-items-center">
        <div class="col-md-3">
            <div class="d-flex align-items-center gap-3">
                <div class="icon-wrapper">
                    <i data-lucide="user" style="width: 24px; height: 24px; color: white;"></i>
                </div>
                <div class="flex-grow-1">
                    <h5 class="mb-1" style="color: #212529; font-weight: 600;">
                        <%= nombre + " " + apellido %>
                    </h5>
                    <span class="badge-estado <%= claseBadge %>">
                        <i data-lucide="alert-circle"
                           style="width: 12px; height: 12px;"></i>

                        <%= estado %>
                    </span>
                </div>
            </div>
        </div>

        <div class="col-md-2">
            <div class="info-label">Fecha</div>
            <div class="d-flex align-items-center gap-2">
                <i data-lucide="calendar" style="width: 16px; height: 16px; color: #6c757d;"></i>
                <span class="info-value"><%= sdfFecha.format(fecha) %></span>
            </div>
        </div>

        <div class="col-md-2">
            <div class="info-label">Hora</div>
            <div class="time-badge">
                <i data-lucide="clock" style="width: 16px; height: 16px; color: var(--color-principal);"></i>
                <%= sdfHora.format(fecha) %>
            </div>
        </div>

        <div class="col-md-2">
            <div class="info-label">Motivo</div>
            <div class="info-value"><%= motivo %></div>
        </div>

        <div class="col-md-3">
            <div class="info-label mb-2">Código Videollamada</div>
            <div class="badge-codigo mb-3">
                <i data-lucide="video" style="width: 16px; height: 16px;"></i>
                <%= ticket %>
            </div>
            
            <div class="d-flex gap-2 mb-2">
                <%
                    boolean puedeUnirse =
                        !"Cancelada".equalsIgnoreCase(estado);
                %>

                <% if (puedeUnirse) { %>

                    <a href="SvVideoConsulta?ticket=<%= ticket %>&idCita=<%= idCita %>"
                       class="btn btn-action btn-join flex-grow-1">
                        <i data-lucide="video"></i> Unirse
                    </a>

                <% } else { %>

                    <button
                        class="btn btn-secondary flex-grow-1"
                        disabled
                        title="La cita fue cancelada">

                        <i data-lucide="video-off"></i>
                        Cancelada

                    </button>

                <% } %>
                <button
                    class="btn btn-action btn-details"

                    data-bs-toggle="modal"
                    data-bs-target="#modalInfo"

                    data-id="<%= idCita %>"
                    data-paciente="<%= nombre + " " + apellido %>"
                    data-motivo="<%= motivo %>"
                    data-fecha="<%= sdfIso.format(fecha) %>"
                    data-puede-modificar="<%= puedeModificar %>"
                    data-id-medico="<%= (medico != null ? medico.getIdMedico() : 0) %>">
                    
                    <i data-lucide="info"></i>

                </button>
            </div>
            
            <a href="SvReporteCitas?tipo=pdf_paciente&id_paciente=<%= id_Paciente %>"
                target="_blank"
                class="btn btn-action btn-danger w-100" style="background-color: #dc3545;">
                <i data-lucide="file-text"></i> Historial (<%= nombre %>)
            </a>
        </div>
    </div> </div>
    <%
            }
        } else {
    %>
     <div class="alert alert-info text-center mt-4">No tienes citas pendientes registradas.</div>
    <%
        }
    %>
    </div>

    <div class="mt-4">
        <a href="HomeMedico.jsp" class="btn btn-primary w-100 py-3" style="font-weight: 600; font-size: 1rem;">
            <i data-lucide="arrow-left" style="width: 20px; height: 20px;"></i> Volver al inicio
        </a>
    </div>
</div>


<div class="modal fade"
     id="modalInfo"
     tabindex="-1">

    <div class="modal-dialog modal-lg modal-dialog-centered">

        <div class="modal-content">

            <div class="modal-header bg-info text-white">

                <h5 class="modal-title">

                    Información de la Cita

                </h5>

                <button
                    type="button"
                    class="btn-close btn-close-white"
                    data-bs-dismiss="modal">
                </button>

            </div>

            <div class="modal-body">
                <!-- INFO GENERAL -->

                <div class="alert alert-light border">

                    <p class="mb-1">

                        <strong>Paciente:</strong>

                        <span id="pacienteInfo"></span>

                    </p>

                    <p class="mb-1">

                        <strong>Motivo:</strong>

                        <span id="motivoInfo"></span>

                    </p>

                    <p class="mb-0">

                        <strong>Fecha actual:</strong>

                        <span id="fechaInfo"></span>

                    </p>

                </div>

                <!-- HISTORIAL -->

                <div id="contenidoInfoCita">

                    <div class="text-center py-4">

                        <div class="spinner-border text-info"></div>

                        <p class="mt-3">

                            Cargando historial...

                        </p>

                    </div>

                </div>

            </div>

            <div class="modal-footer">

                <button
                    type="button"
                    class="btn btn-warning"
                    id="btnAbrirReprogramar">

                    Reprogramar

                </button>

                <button
                    type="button"
                    class="btn btn-danger"
                    id="btnAbrirCancelar">

                    Cancelar

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
<div class="modal fade"
     id="modalReprogramar"
     tabindex="-1">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content">

            <form action="SvReprogramarCita"
                  method="post">

                <div class="modal-header bg-warning">

                    <h5 class="modal-title">

                        Reprogramar Cita

                    </h5>

                    <button type="button"
                            class="btn-close"
                            data-bs-dismiss="modal">
                    </button>

                </div>

                <div class="modal-body">

                    <input type="hidden"
                           name="idCita"
                           id="idCitaModal">

                    <div class="alert alert-secondary">

                        <p class="mb-1">

                            <strong>Paciente:</strong>

                            <span id="pacienteModal"></span>

                        </p>

                        <p class="mb-1">

                            <strong>Motivo:</strong>

                            <span id="motivoModal"></span>

                        </p>

                        <p class="mb-0">

                            <strong>Fecha actual:</strong>

                            <span id="fechaActualModal"></span>

                        </p>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">

                            Nueva fecha

                        </label>

                        <input type="date"
                        class="form-control"
                        id="fechaModal"
                        name="fecha"
                        required>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">

                            Nueva hora

                        </label>

                        <select
                            name="hora"
                            id="horaModal"
                            class="form-select"
                            required>

                            <option value="">
                                Seleccione fecha primero
                            </option>

                        </select>

                    </div>

                    <div class="mb-3">

                        <label class="form-label">

                            Motivo de reprogramación

                        </label>

                        <textarea
                            class="form-control"
                            rows="3"
                            name="motivoReprogramacion"
                            required></textarea>

                    </div>

                </div>

                <div class="modal-footer">

                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">

                        Cerrar

                    </button>

                    <button
                        type="submit"
                        class="btn btn-success">

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

                    <button
                        type="button"
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
                            class="form-control"
                            rows="4"
                            name="motivo"
                            placeholder="Opcional..."></textarea>
                        

                    </div>
                    <div class="alert alert-warning">
                        Esta acción cambiará el estado de la cita a cancelada.
                    </div>
                </div>

                <div class="modal-footer">

                    <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">

                        Cerrar

                    </button>

                    <button
                        type="submit"
                        class="btn btn-danger">

                        Cancelar cita

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>
<script>
    lucide.createIcons();

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

            const paciente =
                button.getAttribute(
                    'data-paciente'
                );

            const motivo =
                button.getAttribute(
                    'data-motivo'
                );

            const fecha =
                button.getAttribute(
                    'data-fecha'
                );

            const puedeModificar =
                String(
                    button.getAttribute(
                        'data-puede-modificar'
                    )
                ).trim() === 'true';

            // GUARDAR ID MEDICO
            idMedicoActual =
                button.getAttribute(
                    'data-id-medico'
                );

            console.log(
                'Puede modificar:',
                puedeModificar
            );

            document
                .getElementById(
                    'btnAbrirReprogramar'
                )
                .dataset.idCita = idCita;

            document
                .getElementById(
                    'btnAbrirCancelar'
                )
                .dataset.idCita = idCita;

            const btnReprogramar =
                document.getElementById(
                    'btnAbrirReprogramar'
                );

            const btnCancelar =
                document.getElementById(
                    'btnAbrirCancelar'
                );

            btnReprogramar.disabled =
                !puedeModificar;

            btnCancelar.disabled =
                !puedeModificar;

            // EFECTO VISUAL
            btnReprogramar.classList.toggle(
                'opacity-50',
                !puedeModificar
            );

            btnCancelar.classList.toggle(
                'opacity-50',
                !puedeModificar
            );

            btnReprogramar.title =
                !puedeModificar
                ? 'Solo puede modificar citas 24h antes o 30 min después de la cita'
                : '';

            btnCancelar.title =
                !puedeModificar
                ? 'Solo puede modificar citas 24h antes o 30 min después de la cita'
                : '';

            document.getElementById(
                'pacienteInfo'
            ).innerText = paciente;

            document.getElementById(
                'motivoInfo'
            ).innerText = motivo;

            document.getElementById(
                'fechaInfo'
            ).innerText = fecha;

            document.getElementById(
                'contenidoInfoCita'
            ).innerHTML =
            `
            <div class="text-center py-4">
                <div class="spinner-border text-info"></div>
                <p class="mt-2">
                    Cargando...
                </p>
            </div>
            `;

            fetch(
                'SvInfoCita?idCita='
                + idCita
            )
            .then(response =>
                response.text()
            )
            .then(html => {

                document.getElementById(
                    'contenidoInfoCita'
                ).innerHTML = html;

            })
            .catch(error => {

                document.getElementById(
                    'contenidoInfoCita'
                ).innerHTML =
                `
                <div class="alert alert-danger">
                    Error al cargar la información.
                </div>
                `;

                console.error(error);

            });

        }
    );

    document
        .getElementById(
            'btnAbrirReprogramar'
        )
        .addEventListener(
            'click',
            function(){

                const idCita =
                    this.dataset.idCita;

                document.getElementById(
                    'idCitaModal'
                ).value = idCita;

                document.getElementById(
                    'pacienteModal'
                ).innerText =
                document.getElementById(
                    'pacienteInfo'
                ).innerText;

                document.getElementById(
                    'motivoModal'
                ).innerText =
                document.getElementById(
                    'motivoInfo'
                ).innerText;

                document.getElementById(
                    'fechaActualModal'
                ).innerText =
                document.getElementById(
                    'fechaInfo'
                ).innerText;

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

    document
        .getElementById(
            'btnAbrirCancelar'
        )
        .addEventListener(
            'click',
            function(){

                const idCita =
                    this.dataset.idCita;

                document.getElementById(
                    'idCitaCancelar'
                ).value = idCita;

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
let idMedicoActual = 0;



// CARGAR HORAS
document.getElementById(
    'fechaModal'
).addEventListener(
    'change',
    function(){

        const fecha =
            this.value;

        fetch(
            '<%= request.getContextPath() %>/SvReprogramarCita?idMedico='
            + idMedicoActual
            + '&fecha='
            + fecha
        )

        .then(response => response.json())

        .then(horas => {

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

            const primera =
                document.createElement(
                    'option'
                );

            primera.value = '';

            primera.textContent =
                'Seleccione una hora';

            combo.appendChild(
                primera
            );

            horas.forEach(hora => {

                const option =
                    document.createElement(
                        'option'
                    );

                option.value = hora;

                option.textContent = hora;

                combo.appendChild(
                    option
                );

            });

        })

        .catch(error => {

            console.log(error);

        });

    }
);
</script>
</body>
</html>
