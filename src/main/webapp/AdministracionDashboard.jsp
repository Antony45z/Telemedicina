<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
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
    <title>Dashboard Citas</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background-color: #f4f6f9;
            padding-top: 90px;
        }

        .navbar-custom {
            background-color: #0DDBA0;
        }

        .chart-container {
            width: 100%;
            max-width: 1100px; 
            margin: 0 auto;
        }

        .card-dashboard {
            padding: 25px;
            border-radius: 14px;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
        }

        #graficoCitas {
            height: 380px !important; 
        }
    </style>
</head>

<body>

<!-- NAV -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
    <div class="container">
        <a class="navbar-brand fw-bold text-white" href="<%= request.getContextPath() %>/PaginaPrincipal.jsp">TeleMedicina Perú</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link text-white fw-semibold active" href="<%= request.getContextPath() %>/DashboardAdmin">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionMedico">Médicos</a></li>
                <li class="nav-item"><a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionPaciente">Pacientes</a></li>
                <li class="nav-item">
            <a class="nav-link text-white fw-semibold active" href="<%= request.getContextPath() %>/PublicacionServlet">Publicaciones</a>
          </li>
                <li class="nav-item"><a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/AdministracionCita">Citas</a></li>
                <li class="nav-item"><a class="nav-link text-white fw-semibold" href="<%= request.getContextPath() %>/PaginaPrincipal.jsp">Cerrar sesión</a></li>
            </ul>
        </div>
    </div>
</nav>


<!-- CONTENIDO -->
<div class="container mt-4 chart-container">
    <div class="card-dashboard">
        <h3 class="text-center mb-3">Citas por Mes - 2026</h3>
        <canvas id="graficoCitas"></canvas>
    </div>
</div>


<!-- SCRIPT -->
<script>
    const meses = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"];

    const citasData = [
        <% 
            Map<Integer, Integer> citasMes = (Map<Integer, Integer>) request.getAttribute("citasMes");
            if (citasMes == null) citasMes = new java.util.HashMap<>();

            for (int i = 1; i <= 12; i++) {
                out.print(citasMes.getOrDefault(i, 0));
                if (i < 12) out.print(",");
            }
        %>
    ];

    new Chart(document.getElementById("graficoCitas"), {
        type: 'bar',
        data: {
            labels: meses,
            datasets: [{
                label: "Citas 2026",
                data: citasData,
                backgroundColor: 'rgba(13, 219, 160, 0.4)',
                borderColor: '#0DDBA0',
                borderWidth: 2,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
</script>

</body>
</html>
