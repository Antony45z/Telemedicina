<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuarios - TeleMed</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.7), rgba(118, 75, 162, 0.7)),
                        url('imagenes/fondo2.jpg') center/cover no-repeat fixed;
        }
        /* ... (Estilos CSS existentes, omitidos por brevedad) ... */
        .card { border: none; border-radius: 15px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); backdrop-filter: blur(10px); background: rgba(255, 255, 255, 0.95); }
        .card-header { background: linear-gradient(135deg, #4facfe, #00f2fe); color: white; border-radius: 15px 15px 0 0 !important; text-align: center; padding: 2rem; }
        .form-control, .form-select { border-radius: 10px; border: 2px solid #e9ecef; padding: 0.75rem 1rem; transition: all 0.3s ease; }
        .form-control:focus, .form-select:focus { border-color: #4facfe; box-shadow: 0 0 0 0.2rem rgba(79,172,254,0.25); transform: translateY(-2px); }
        .btn-primary { background: linear-gradient(135deg, #4facfe, #00f2fe); border: none; border-radius: 10px; padding: 0.75rem 2rem; font-weight: 600; transition: all 0.3s ease; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(79,172,254,0.4); }
        .medical-icon { font-size: 3rem; margin-bottom: 1rem; color: #fff; }
        .login-link { background: rgba(79,172,254,0.1); border-radius: 10px; padding: 1rem; text-align: center; margin-top: 1rem; }
    </style>
</head>
<body>

<%!
    // Función de ayuda para rellenar los atributos 'selected' en los elementos <select>
    public String checkParam(HttpServletRequest req, String paramName, String value) {
        String paramValue = req.getParameter(paramName);
        return (paramValue != null && paramValue.equals(value)) ? " selected" : "";
    }
%>

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8 col-md-10">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-user-md medical-icon"></i>
                    <h3 class="mb-0">Registro de Usuario</h3>
                    <p class="mb-0 mt-2">Plataforma de Telemedicina</p>
                </div>
                <div class="card-body p-4">
                    <%
                        // Lógica para mostrar mensajes de error/éxito del Servlet
                        String mensaje = (String) request.getAttribute("mensaje");
                        String tipoMensaje = (String) request.getAttribute("tipoMensaje");
                        if (mensaje != null) {
                    %>
                    <div class="alert alert-<%= tipoMensaje != null ? tipoMensaje : "info" %>" role="alert">
                        <i class="fas fa-info-circle me-2"></i><%= mensaje %>
                    </div>
                    <% } %>

                    <form action="RegistroServlet" method="POST" id="registroForm" novalidate>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Nombres: Rellena el valor --%>
                                    <input type="text"
                                    class="form-control"
                                    id="nombres"
                                    name="nombres"
                                    placeholder="Nombres"
                                    required
                                    maxlength="100"
                                    pattern="^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$"
                                    title="Solo se permiten letras"
                                    value="<%= request.getParameter("nombres") != null ? request.getParameter("nombres") : "" %>">
                                    <label for="nombres"><i class="fas fa-user me-2"></i>Nombres</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Apellidos: Rellena el valor --%>
                                    <input type="text"
                                    class="form-control"
                                    id="apellidos"
                                    name="apellidos"
                                    placeholder="Apellidos"
                                    required
                                    maxlength="100"
                                    pattern="^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$"
                                    title="Solo se permiten letras"
                                    value="<%= request.getParameter("apellidos") != null ? request.getParameter("apellidos") : "" %>">
                                    <label for="apellidos"><i class="fas fa-user me-2"></i>Apellidos</label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- SELECT Tipo Documento: Usa la función checkParam para seleccionar la opción correcta --%>
                                    <select class="form-select" id="tipoDocumento" name="tipoDocumento" required>
                                        <option value="">Seleccionar</option>
                                        <option value="DNI" <%= checkParam(request, "tipoDocumento", "DNI") %>>DNI</option>
                                        <option value="CARNET_EXTRANJERIA" <%= checkParam(request, "tipoDocumento", "CARNET_EXTRANJERIA") %>>Carnet de Extranjería</option>
                                        <option value="PASAPORTE" <%= checkParam(request, "tipoDocumento", "PASAPORTE") %>>Pasaporte</option>
                                    </select>
                                    <label for="tipoDocumento"><i class="fas fa-id-card me-2"></i>Tipo de Documento</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Número Documento: Rellena el valor --%>
                                    <input type="text" class="form-control" id="numeroDocumento" name="numeroDocumento" placeholder="Número de Documento" required maxlength="20" pattern="[A-Za-z0-9]+"
                                           value="<%= request.getParameter("numeroDocumento") != null ? request.getParameter("numeroDocumento") : "" %>">
                                    <label for="numeroDocumento"><i class="fas fa-hashtag me-2"></i>Número de Documento</label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Fecha Nacimiento: Rellena el valor --%>
                                    <input type="date" class="form-control" id="fechaNacimiento" name="fechaNacimiento" required max="<%= java.time.LocalDate.now() %>"
                                           value="<%= request.getParameter("fechaNacimiento") != null ? request.getParameter("fechaNacimiento") : "" %>">
                                    <label for="fechaNacimiento"><i class="fas fa-calendar me-2"></i>Fecha de Nacimiento</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- SELECT Género: Rellena el valor --%>
                                    <select class="form-select" id="genero" name="genero" required>
                                        <option value="">Seleccionar</option>
                                        <option value="Masculino" <%= checkParam(request, "genero", "Masculino") %>>Masculino</option>
                                        <option value="Femenino" <%= checkParam(request, "genero", "Femenino") %>>Femenino</option>
                                        <option value="Otro" <%= checkParam(request, "genero", "Otro") %>>Prefiero no especificar</option>
                                    </select>
                                    <label for="genero"><i class="fas fa-venus-mars me-2"></i>Género</label>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Email: Rellena el valor --%>
                                    <input type="email"
                                    class="form-control"
                                    id="email"
                                    name="email"
                                    placeholder="correo@ejemplo.com"
                                    required
                                    maxlength="150"
                                    pattern="^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"
                                    value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                                    <label for="email"><i class="fas fa-envelope me-2"></i>Correo Electrónico</label>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- Campo Teléfono: Rellena el valor --%>
                                    <input type="tel" class="form-control" id="telefono" name="telefono" placeholder="Teléfono" required maxlength="20" pattern="[0-9+\-\s()]+"
                                           value="<%= request.getParameter("telefono") != null ? request.getParameter("telefono") : "" %>">
                                    <label for="telefono"><i class="fas fa-phone me-2"></i>Teléfono</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <div class="form-floating">
                                <%-- TEXTAREA Dirección: Rellena el valor entre las etiquetas --%>
                                <textarea class="form-control" id="direccion" name="direccion" placeholder="Dirección" style="height: 80px" maxlength="200"><%= request.getParameter("direccion") != null ? request.getParameter("direccion") : "" %></textarea>
                                <label for="direccion"><i class="fas fa-map-marker-alt me-2"></i>Dirección</label>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="form-floating">
                                    <%-- SELECT Tipo Usuario: Rellena el valor --%>
                                    <select class="form-select" id="tipoUsuario" name="tipoUsuario" required onchange="mostrarCampos()">
                                        <option value="">Seleccionar</option>
                                        <option value="PACIENTE" <%= checkParam(request, "tipoUsuario", "PACIENTE") %>>Paciente</option>
                                        <option value="MEDICO" <%= checkParam(request, "tipoUsuario", "MEDICO") %>>Médico</option>
                                    </select>
                                    <label for="tipoUsuario"><i class="fas fa-user-tag me-2"></i>Tipo de Usuario</label>
                                </div>
                            </div>
                        </div>

                        <div id="camposPaciente" style="display:none;">
                            <h5 class="mt-3">Datos del Paciente</h5>
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <%-- SELECT Grupo Sanguíneo: Rellena el valor --%>
                                        <select class="form-select" id="grupoSanguineo" name="grupoSanguineo">
                                            <option value="">Seleccionar Grupo Sanguíneo</option>
                                            <option value="A+" <%= checkParam(request, "grupoSanguineo", "A+") %>>A+</option>
                                            <option value="A-" <%= checkParam(request, "grupoSanguineo", "A-") %>>A-</option>
                                            <option value="B+" <%= checkParam(request, "grupoSanguineo", "B+") %>>B+</option>
                                            <option value="B-" <%= checkParam(request, "grupoSanguineo", "B-") %>>B-</option>
                                            <option value="AB+" <%= checkParam(request, "grupoSanguineo", "AB+") %>>AB+</option>
                                            <option value="AB-" <%= checkParam(request, "grupoSanguineo", "AB-") %>>AB-</option>
                                            <option value="O+" <%= checkParam(request, "grupoSanguineo", "O+") %>>O+</option>
                                            <option value="O-" <%= checkParam(request, "grupoSanguineo", "O-") %>>O-</option>
                                        </select>
                                        <label for="grupoSanguineo">Grupo Sanguíneo</label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-floating">
                                        <%-- Campo Peso: Rellena el valor --%>
                                        <input type="number" step="0.01" min="1" max="500" class="form-control" id="peso" name="peso" placeholder="Peso"
                                               value="<%= request.getParameter("peso") != null ? request.getParameter("peso") : "" %>">
                                        <label for="peso">Peso (kg)</label>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="form-floating">
                                        <%-- Campo Altura: Rellena el valor --%>
                                        <input type="number" step="0.01" min="0.3" max="3" class="form-control" id="altura" name="altura" placeholder="Altura"
                                               value="<%= request.getParameter("altura") != null ? request.getParameter("altura") : "" %>">
                                        <label for="altura">Altura (m)</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="camposMedico" style="display:none;">
                            <h5 class="mt-3">Datos del Médico</h5>
                            <div class="mb-3">
                                <div class="form-floating">
                                    <%-- Campo Colegiatura: Rellena el valor --%>
                                    <input type="text" class="form-control" id="numeroColegiatura" name="numeroColegiatura" placeholder="Número de Colegiatura"
                                           value="<%= request.getParameter("numeroColegiatura") != null ? request.getParameter("numeroColegiatura") : "" %>">
                                    <label for="numeroColegiatura">N° Colegiatura</label>
                                </div>
                            </div>
                            <div class="mb-3">
                                <div class="form-floating">
                                    <%-- Campo Especialidad: Rellena el valor --%>
                                    <input type="text" class="form-control" id="especialidad" name="especialidad" placeholder="Especialidad"
                                           value="<%= request.getParameter("especialidad") != null ? request.getParameter("especialidad") : "" %>">
                                    <label for="especialidad">Especialidad</label>
                                </div>
                            </div>
                            <%-- Nota: Faltan campos de Médico como 'experiencia' y 'centroLaboral' según tu Servlet, ¡deberías añadirlos aquí! --%>
                            <div class="mb-3">
                                <div class="form-floating">
                                    <%-- Campo Experiencia (Añadido): Rellena el valor --%>
                                    <input type="number" min="0" class="form-control" id="aniosExperiencia" name="aniosExperiencia" placeholder="Años de Experiencia"
                                           value="<%= request.getParameter("aniosExperiencia") != null ? request.getParameter("aniosExperiencia") : "" %>">
                                    <label for="aniosExperiencia">Años de Experiencia</label>
                                </div>
                            </div>
                             <div class="mb-3">
                                <div class="form-floating">
                                    <%-- Campo Centro Laboral (Añadido): Rellena el valor --%>
                                    <input type="text" class="form-control" id="centroLaboral" name="centroLaboral" placeholder="Centro Laboral"
                                           value="<%= request.getParameter("centroLaboral") != null ? request.getParameter("centroLaboral") : "" %>">
                                    <label for="centroLaboral">Centro Laboral</label>
                                </div>
                            </div>
                             <div class="mb-3">
                                <div class="form-floating">
                                    <%-- Campo Descripción (Añadido): Rellena el valor --%>
                                    <textarea class="form-control" id="descripcion" name="descripcion" placeholder="Descripción" style="height: 80px" maxlength="500"><%= request.getParameter("descripcion") != null ? request.getParameter("descripcion") : "" %></textarea>
                                    <label for="descripcion"><i class="fas fa-notes-medical me-2"></i>Descripción (Bio)</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-2">
                            <div class="form-floating">
                                <input type="password"
                                class="form-control"
                                id="password"
                                name="password"
                                placeholder="Contraseña"
                                required
                                minlength="8"
                                maxlength="30">
                                <label for="password"><i class="fas fa-lock me-2"></i>Contraseña</label>
                                <small id="passwordHelp" class="text-muted">
La contraseña debe tener entre 8 y 30 caracteres,
incluyendo mayúscula, minúscula, número y símbolo.
</small>
                            </div>
                        </div>
                        <div class="mb-3 ms-1">
                            <input type="checkbox" id="mostrarPassword" style="width:auto; margin-right:5px;">
                            <label for="mostrarPassword" style="font-size:14px;">Mostrar contraseña</label>
                        </div>

                        <div class="mb-2">
                            <div class="form-floating">
                                <input type="password"
                                class="form-control"
                                id="confirmarPassword"
                                name="confirmarPassword"
                                placeholder="Confirmar Contraseña"
                                required
                                minlength="8"
                                maxlength="30">
                                <label for="confirmarPassword"><i class="fas fa-lock me-2"></i>Confirmar Contraseña</label>
                            </div>
                        </div>
                        <div class="mb-4 ms-1">
                            <input type="checkbox" id="mostrarConfirmarPassword" style="width:auto; margin-right:5px;">
                            <label for="mostrarConfirmarPassword" style="font-size:14px;">Mostrar contraseña</label>
                        </div>

                        <div class="mb-4">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="terminos" name="terminos" required
                                       <%= request.getParameter("terminos") != null ? "checked" : "" %>>
                                <label class="form-check-label" for="terminos">
                                    Acepto los <a href="#" class="text-decoration-none">Términos y Condiciones</a> y la <a href="#" class="text-decoration-none">Política de Privacidad</a>
                                </label>
                            </div>
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-user-plus me-2"></i>Registrarse</button>
                        </div>
                    </form>

                    <div class="login-link">
                        <p class="mb-0">¿Ya tienes una cuenta?
                            <a href="login.jsp" class="text-decoration-none fw-bold">Inicia Sesión</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal de Registro Exitoso -->
<div class="modal fade" id="modalExito" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 15px;">
      <div class="modal-body text-center p-4">
        <i class="fas fa-check-circle text-success" style="font-size: 4rem;"></i>
        <h4 class="mt-3 mb-2">¡Registro Exitoso!</h4>
        <p class="text-muted mb-4">Tu cuenta ha sido creada correctamente.</p>
        <button type="button" class="btn btn-primary px-4" onclick="window.location.href='login.jsp'">
            Aceptar
        </button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" defer></script>
<script defer>
    function mostrarCampos() {
        const tipo = document.getElementById('tipoUsuario').value;
        document.getElementById('camposPaciente').style.display = tipo === 'PACIENTE' ? 'block' : 'none';
        document.getElementById('camposMedico').style.display = tipo === 'MEDICO' ? 'block' : 'none';

        // Gestión de 'required' para campos condicionales (opcional, el Servlet también valida)
        document.getElementById('numeroColegiatura').required = tipo === 'MEDICO';
        // Aquí podrías agregar o quitar el atributo 'required' de otros campos si lo necesitas
    }

    // Asegura que los campos condicionales se muestren correctamente cuando la página se carga (después de un forward por error)
    window.onload = function() {
        mostrarCampos();
    };

    // MOSTRAR / OCULTAR CONTRASEÑA
    document.getElementById("mostrarPassword").addEventListener("change", function () {
        document.getElementById("password").type = this.checked ? "text" : "password";
    });

    document.getElementById("mostrarConfirmarPassword").addEventListener("change", function () {
        document.getElementById("confirmarPassword").type = this.checked ? "text" : "password";
    });

    document.getElementById('registroForm').addEventListener('submit', function(e){

        const password = document.getElementById('password').value.trim();
        const confirmarPassword = document.getElementById('confirmarPassword').value.trim();

        const nombres = document.getElementById('nombres').value.trim();
        const apellidos = document.getElementById('apellidos').value.trim();

        const email = document.getElementById('email').value.trim();

        // PASSWORD
        const regexPassword =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_]).{8,30}$/;

        // SOLO LETRAS
        const regexTexto =
            /^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$/;

        // EMAIL
        const regexEmail =
            /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        if(password !== confirmarPassword){
            e.preventDefault();
            alert('Las contraseñas no coinciden');
            return false;
        }

        if(!regexPassword.test(password)){
            e.preventDefault();
            alert('La contraseña debe tener mayúscula, minúscula, número y símbolo');
            return false;
        }

        if(!regexTexto.test(nombres)){
            e.preventDefault();
            alert('Los nombres solo pueden contener letras');
            return false;
        }

        if(!regexTexto.test(apellidos)){
            e.preventDefault();
            alert('Los apellidos solo pueden contener letras');
            return false;
        }

        if(!regexEmail.test(email)){
            e.preventDefault();
            alert('Ingrese un correo válido');
            return false;
        }
    });
</script>

<%
    Boolean registroExitoso = (Boolean) request.getAttribute("registroExitoso");
%>
<% if (registroExitoso != null && registroExitoso) { %>
<script defer>
    document.addEventListener('DOMContentLoaded', function () {
        var modalExito = new bootstrap.Modal(document.getElementById('modalExito'), {
            backdrop: 'static', // no se cierra haciendo clic afuera
            keyboard: false     // no se cierra con ESC
        });
        modalExito.show();
    });
</script>
<% } %>
</body>
</html>
