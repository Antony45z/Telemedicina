<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Citas - TELEMED</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --color-principal: #0DDBA0;
            --color-secundario: #e6f9f6;
        }
        body { padding-top: 80px; background-color: var(--color-secundario); }
        .navbar-brand { font-weight: bold; color: var(--color-principal) !important; }
        .nav-link.active { color: var(--color-principal) !important; font-weight: bold; }
        .card-title { color: var(--color-principal); }
        .table thead { background-color: var(--color-principal); color: white; }
        .btn-primary { background-color: var(--color-principal); border: none; }
        .btn-primary:hover { background-color: #0ab391; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg bg-light fixed-top shadow-sm" style="border-bottom: 4px solid var(--color-principal);">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">TELEMED</a>
        <div class="collapse navbar-collapse" id="navbarDoctor">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="HomeMedico.jsp">Inicio</a></li>
                <li class="nav-item"><a class="nav-link active" href="VerCitaMedico.jsp">Ver Citas</a></li>
                <li class="nav-item"><a class="nav-link" href="PerfilMedico.jsp">Perfil Médico</a></li>
                 <li class="nav-item"><a class="nav-link" href="VideoConsultaMedico.jsp">VideoConsulta</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <span class="me-3 fw-bold">Dr. Invitado</span>
                <a class="btn btn-outline-danger btn-sm" href="PaginaPrincipal.jsp">Cerrar Sesión</a>
            </div>
        </div>
    </div>
</nav>

<!-- Contenido -->
<div class="container mt-5 pt-4">
    <div class="card shadow-sm p-4">
        <h3 class="card-title mb-4">Citas agendadas por los pacientes</h3>

        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle text-center">
                <thead>
                    <tr>
                        <th>Paciente</th>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Motivo</th>
                        <th>Código Videollamada</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Datos de ejemplo -->
                    <tr>
                        <td>Juan Pérez</td>
                        <td>2025-09-30</td>
                        <td>10:00 AM</td>
                        <td>Consulta general</td>
                        <td><span class="fw-bold text-primary">ABC-123</span></td>
                    </tr>
                    <tr>
                        <td>María López</td>
                        <td>2025-10-01</td>
                        <td>3:30 PM</td>
                        <td>Dolor de cabeza</td>
                        <td><span class="fw-bold text-primary">ABC-123</span></td>
                    </tr>
                    <tr>
                        <td colspan="5" class="text-muted">Fin de la lista de citas</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <a href="homeDoctor.jsp" class="btn btn-primary mt-3">Volver al inicio</a>
    </div>
</div>
</body>
</html>
