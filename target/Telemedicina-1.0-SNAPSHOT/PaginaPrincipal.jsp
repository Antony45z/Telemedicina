<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <title>TeleMedicina Perú</title>
        <style>
            :root {
                --color-principal: #0DDBA0;
                --color-secundario: #00b894;
                --color-dark: #2d3436;
                --color-light: #ddd;
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                scroll-behavior: smooth;
                overflow-x: hidden;
            }

            /* Header Superior */
            .top-header {
                background: linear-gradient(135deg, #a64ac9 0%, #8e44ad 100%);
                color: white;
                padding: 10px 0;
                font-size: 14px;
            }

            .top-header .contact-info {
                display: flex;
                align-items: center;
                gap: 30px;
                flex-wrap: wrap;
            }

            .top-header .contact-item {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .social-links {
                display: flex;
                gap: 10px;
            }

            .social-links a {
                color: white;
                width: 35px;
                height: 35px;
                border-radius: 50%;
                background: rgba(255,255,255,0.1);
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .social-links a:hover {
                background: rgba(255,255,255,0.2);
                transform: translateY(-2px);
            }

            /* Navbar Principal */
            .main-navbar {
                background: rgba(0, 0, 0, 0.9);
                backdrop-filter: blur(10px);
                border: none;
                padding: 15px 0;
                transition: all 0.3s ease;
                position: absolute;
                top: 50;
                left:0;
                right: 0;
                z-index: 1000;
            }

            .main-navbar.scrolled {
                background: rgba(0, 0, 0, 0.95);
                backdrop-filter: blur(10px);
                position: fixed;
                top: 0;
                padding: 10px 0;
            }

            .navbar-brand {
                font-weight: 700;
                font-size: 2rem;
                color: var(--color-principal) !important;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .navbar-brand::before {
                content: "";
                font-size: 1.5rem;
            }

            .navbar-nav .nav-link {
                color: white !important;
                font-weight: 500;
                padding: 8px 20px !important;
                margin: 0 5px;
                border-radius: 25px;
                transition: all 0.3s ease;
                position: relative;
            }

            .navbar-nav .nav-link:hover,
            .navbar-nav .nav-link.active {
                color: var(--color-principal) !important;
                background: rgba(13, 219, 160, 0.1);
                transform: translateY(-2px);
            }

            .login-btn {
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                border: none;
                padding: 10px 25px;
                border-radius: 25px;
                color: white !important;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(13, 219, 160, 0.3);
                cursor: pointer;
            }

            .login-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(13, 219, 160, 0.4);
                color: white !important;
            }

            /* Hero Section con Carrusel */
            .hero-carousel {
                position: relative;
            }

            .carousel-item img {
                height: 100vh;
                object-fit: cover;
                filter: brightness(0.6);
            }

            .carousel-caption {
                left: 10%;
                right: 10%;
                bottom: 30%;
                text-align: left;
            }

            .hero-title {
                font-size: 3.5rem;
                font-weight: 700;
                margin-bottom: 20px;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.7);
                animation: fadeInUp 1s ease;
            }

            .hero-subtitle {
                font-size: 1.3rem;
                margin-bottom: 30px;
                line-height: 1.6;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.7);
                animation: fadeInUp 1s ease 0.2s both;
            }

            .hero-cta {
                display: flex;
                gap: 20px;
                flex-wrap: wrap;
                animation: fadeInUp 1s ease 0.4s both;
            }

            .cta-primary, .cta-secondary {
                padding: 15px 30px;
                border-radius: 50px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                cursor: pointer;
            }

            .cta-primary {
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                color: white;
                box-shadow: 0 4px 20px rgba(13, 219, 160, 0.3);
                border: none;
            }

            .cta-secondary {
                background: transparent;
                color: white;
                border: 2px solid white;
            }

            .cta-primary:hover, .cta-secondary:hover {
                transform: translateY(-3px);
                color: white;
            }

            .cta-primary:hover {
                box-shadow: 0 6px 25px rgba(13, 219, 160, 0.4);
            }

            .cta-secondary:hover {
                background: white;
                color: var(--color-dark);
            }

            /* Secciones */
            section {
                padding: 80px 0;
            }

            .section-title {
                font-size: 2.5rem;
                font-weight: 700;
                text-align: center;
                margin-bottom: 20px;
                color: var(--color-dark);
            }

            .section-subtitle {
                text-align: center;
                font-size: 1.1rem;
                color: #666;
                max-width: 600px;
                margin: 0 auto 60px;
                line-height: 1.6;
            }

            /* About Section */
            #nosotros {
                background: #f8f9fa;
            }

            .about-content {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 60px;
                align-items: center;
            }

            .about-text h3 {
                color: var(--color-principal);
                font-size: 1.8rem;
                margin-bottom: 20px;
            }

            .about-text p {
                font-size: 1.1rem;
                line-height: 1.7;
                color: #555;
                margin-bottom: 15px;
            }

            .about-video {
                position: relative;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            }

            /* Features Section */
            .feature-card {
                background: white;
                padding: 40px 30px;
                border-radius: 15px;
                text-align: center;
                transition: all 0.3s ease;
                border: 1px solid #eee;
                height: 100%;
                cursor: pointer;
            }

            .feature-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            }

            .feature-icon {
                width: 80px;
                height: 80px;
                margin: 0 auto 20px;
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                color: white;
            }

            .feature-title {
                font-size: 1.3rem;
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--color-dark);
            }

            .feature-text {
                color: #666;
                line-height: 1.6;
            }

            /* Doctors Section */
            .doctor-card {
                background: white;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .doctor-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            }

            .doctor-image {
                width: 100%;
                height: 250px;
                object-fit: cover;
                border-radius: 15px 15px 0 0;
            }

            .doctor-info {
                padding: 25px;
            }

            .doctor-name {
                font-size: 1.3rem;
                font-weight: 600;
                color: var(--color-dark);
                margin-bottom: 10px;
            }

            .doctor-specialty {
                color: var(--color-principal);
                font-weight: 500;
                margin-bottom: 15px;
            }

            .doctor-description {
                color: #666;
                font-size: 0.95rem;
                line-height: 1.5;
                margin-bottom: 10px;
            }

            /* Contact Section */
            .contact-info-card, .contact-form-card {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                height: 100%;
            }

            .contact-info-card h4, .contact-form-card h4 {
                color: var(--color-principal);
                margin-bottom: 30px;
                font-size: 1.4rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .contact-items {
                display: flex;
                flex-direction: column;
                gap: 25px;
            }

            .contact-items .contact-item {
                display: flex;
                align-items: flex-start;
                gap: 15px;
            }

            .contact-items .contact-item i {
                color: var(--color-principal);
                font-size: 1.2rem;
                margin-top: 3px;
                min-width: 20px;
            }

            .contact-items .contact-item strong {
                color: var(--color-dark);
                display: block;
                margin-bottom: 5px;
            }

            .contact-items .contact-item p {
                color: #666;
                margin: 0;
            }

            .contact-form {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1rem;
                transition: border-color 0.3s ease;
                font-family: 'Poppins', sans-serif;
            }

            .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
                outline: none;
                border-color: var(--color-principal);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .submit-btn {
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(13, 219, 160, 0.3);
            }

            /* Footer */
            footer {
                background: linear-gradient(135deg, var(--color-dark), #000);
                color: white;
                padding: 50px 0 20px;
            }

            .footer-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 40px;
                margin-bottom: 30px;
            }

            .footer-section h4 {
                color: var(--color-principal);
                margin-bottom: 20px;
                font-weight: 600;
            }

            .footer-section p, .footer-section li {
                color: #ccc;
                line-height: 1.6;
                margin-bottom: 10px;
            }

            .footer-section ul {
                list-style: none;
            }

            .footer-section a {
                color: #ccc;
                text-decoration: none;
                transition: color 0.3s ease;
            }

            .footer-section a:hover {
                color: var(--color-principal);
            }

            .footer-bottom {
                border-top: 1px solid #444;
                padding-top: 20px;
                text-align: center;
                color: #999;
            }

            /* Modal Styles */
            .modal-content {
                border-radius: 15px;
                border: none;
            }

            .modal-header {
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                color: white;
                border-radius: 15px 15px 0 0;
            }

            /* Notification */
            .notification {
                position: fixed;
                top: 100px;
                right: 20px;
                background: linear-gradient(135deg, var(--color-principal), var(--color-secundario));
                color: white;
                padding: 15px 25px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(13, 219, 160, 0.3);
                transform: translateX(100%);
                transition: transform 0.3s ease;
                z-index: 9999;
            }

            .notification.show {
                transform: translateX(0);
            }

            /* Animaciones */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes pulse {
                0% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.05);
                }
                100% {
                    transform: scale(1);
                }
            }

            .fade-in {
                opacity: 0;
                transform: translateY(30px);
                transition: all 0.8s ease;
            }

            .fade-in.show {
                opacity: 1;
                transform: translateY(0);
            }

            .pulse-animation {
                animation: pulse 2s infinite;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .top-header {
                    text-align: center;
                    padding: 15px 0;
                }

                .top-header .contact-info {
                    justify-content: center;
                    gap: 15px;
                }

                .hero-title {
                    font-size: 2.5rem;
                }

                .hero-subtitle {
                    font-size: 1.1rem;
                }

                .about-content {
                    grid-template-columns: 1fr;
                    gap: 40px;
                }

                .hero-cta {
                    justify-content: center;
                }

                .cta-primary, .cta-secondary {
                    flex: 1;
                    text-align: center;
                    justify-content: center;
                    min-width: 200px;
                }

                .carousel-caption {
                    left: 5%;
                    right: 5%;
                    bottom: 20%;
                }
            }

            @media (max-width: 576px) {
                .hero-cta {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header Superior -->
        <div class="top-header">
            <div class="container-fluid">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="contact-info">
                            <div class="contact-item">
                                <i class="fas fa-phone"></i>
                                <span>+51 935 222 034</span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-envelope"></i>
                                <span>info@telemedincinoperu.com</span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span>Lima - Perú</span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-clock"></i>
                                <span>Citas Médicas con Anticipación de 24 Hrs.</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="social-links">
                            <a href="#" onclick="showNotification('¡Síguenos en Facebook!')"><i class="fab fa-facebook-f"></i></a>
                            <a href="#" onclick="showNotification('¡Síguenos en Instagram!')"><i class="fab fa-instagram"></i></a>
                            <a href="#" onclick="showNotification('¡Conéctate en LinkedIn!')"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#" onclick="showNotification('¡Suscríbete a nuestro canal!')"><i class="fab fa-youtube"></i></a>
                            <a href="#" onclick="showNotification('¡Síguenos en TikTok!')"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navbar Principal -->
        <nav class="navbar navbar-expand-lg main-navbar" id="mainNavbar">
            <div class="container-fluid">
                <a class="navbar-brand" href="#inicio">TeleMed</a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" style="border: 1px solid var(--color-principal);">
                    <i class="fas fa-bars" style="color: var(--color-principal);"></i>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link active" href="#inicio" onclick="setActiveNav(this)">INICIO</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#nosotros" onclick="setActiveNav(this)">NOSOTROS</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#servicios" onclick="setActiveNav(this)">PRODUCTOS & SERVICIOS</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#doctores" onclick="setActiveNav(this)">DOCTORES</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#teleconsulta" onclick="setActiveNav(this)">TELECONSULTA</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#contacto" onclick="setActiveNav(this)">CONTACTOS</a>
                        </li>
                    </ul>

                    <button class="login-btn" onclick="location.href='login.jsp'">
                        <i class="fas fa-user"></i> Login
                    </button>
                </div>
            </div>
        </nav>

        <!-- Hero Section con Carrusel -->
        <section id="inicio" class="hero-carousel">
            <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="5000">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
                </div>

                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="https://static.vecteezy.com/system/resources/previews/069/358/516/non_2x/doctor-with-stethoscope-standing-before-a-digital-network-healthcare-technology-free-photo.jpg" class="d-block w-100" alt="Telemedicina">
                        <div class="carousel-caption">
                            <h1 class="hero-title">TeleMedicina Perú</h1>
                            <p class="hero-subtitle">
                                Primera institución privada dedicada íntegramente a la implementación de tecnologías de la información, 
                                informática y telecomunicaciones para la mejora de los servicios de salud.
                            </p>
                            <div class="hero-cta">
                                <button class="cta-primary" onclick="scrollToSection('servicios')">
                                    <i class="fas fa-stethoscope"></i>
                                    Nuestros Servicios
                                </button>
                                <button class="cta-secondary" onclick="showConsultaModal()">
                                    <i class="fas fa-video"></i>
                                    Iniciar Consulta
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="carousel-item">
                        <img src="https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=1920&h=1080&fit=crop&crop=center" class="d-block w-100" alt="Consultas en línea">
                        <div class="carousel-caption">
                            <h1 class="hero-title">Consultas en Línea</h1>
                            <p class="hero-subtitle">
                                Accede a médicos especialistas sin salir de casa. Ahorra tiempo y recibe atención inmediata 
                                para ti y tu familia con la mejor tecnología digital en salud.
                            </p>
                            <div class="hero-cta">
                                <button class="cta-primary" onclick="showConsultaModal()">
                                    <i class="fas fa-video"></i>
                                    Agendar Consulta
                                </button>
                                <button class="cta-secondary" onclick="scrollToSection('doctores')">
                                    <i class="fas fa-user-md"></i>
                                    Ver Doctores
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                </button>
            </div>
        </section>

        <!-- Sección Nosotros -->
        <section id="nosotros" class="fade-in">
            <div class="container">
                <h2 class="section-title">Bienvenido a TeleMed Perú</h2>
                <p class="section-subtitle">
                    Somos una plataforma de salud digital diseñada para comunidades remotas. 
                    Nuestro objetivo es acercar la atención médica a cada persona sin importar su ubicación.
                </p>

                <div class="about-content">
                    <div class="about-text">
                        <h3><i class="fas fa-heart-pulse"></i> Sobre Nuestros Servicios</h3>
                        <p>
                            En <strong>TeleMed Perú</strong> creemos que la salud debe estar al alcance de todos.
                            Nuestros servicios incluyen <strong>atención médica en línea</strong>, <strong>recetas digitales</strong>, 
                            <strong>telemonitoreo</strong> y <strong>planes accesibles</strong> para cada necesidad.
                        </p>
                        <p>
                            Gracias a la <strong>tecnología</strong>, ahora puedes acceder a especialistas desde cualquier lugar,
                            reduciendo <em>tiempos de espera</em> y mejorando la <em>calidad</em> de tu atención médica.
                        </p>
                    </div>

                    <div class="about-video">
                        <div class="ratio ratio-16x9">
                            <iframe 
                                src="https://www.youtube.com/embed/8MqFJrbuaw8" 
                                title="Video informativo de TeleMedicina" 
                                frameborder="0"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
                                allowfullscreen>
                            </iframe>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección Servicios -->
        <section id="servicios" class="fade-in">
            <div class="container">
                <h2 class="section-title">¿Por qué elegir TeleMed?</h2>
                <p class="section-subtitle">
                    Ofrecemos servicios médicos de calidad con la mejor tecnología y profesionales altamente capacitados
                </p>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-card" onclick="showFeatureModal('Atención 24/7', 'Siempre disponibles para ti. Accede a consultas médicas en cualquier momento del día, los 365 días del año.')">
                            <div class="feature-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <h4 class="feature-title">Atención 24/7</h4>
                            <p class="feature-text">
                                Siempre disponibles para ti. Accede a consultas médicas en cualquier momento del día.
                            </p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card" onclick="showFeatureModal('Doctores de Calidad', 'Profesionales altamente capacitados y certificados en diversas especialidades médicas, con años de experiencia.')">
                            <div class="feature-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h4 class="feature-title">Doctores de Calidad</h4>
                            <p class="feature-text">
                                Profesionales altamente capacitados y certificados en diversas especialidades médicas.
                            </p>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="feature-card" onclick="showFeatureModal('Precio Accesible', 'Salud al alcance de todos. Planes flexibles y precios competitivos para cada necesidad y presupuesto.')">
                            <div class="feature-icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <h4 class="feature-title">Precio Accesible</h4>
                            <p class="feature-text">
                                Salud al alcance de todos. Planes flexibles y precios competitivos para cada necesidad.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección Doctores -->
        <section id="doctores" class="fade-in" style="background: #f8f9fa;">
            <div class="container">
                <h2 class="section-title">Doctores Destacados</h2>
                <p class="section-subtitle">
                    Conoce a nuestro equipo de especialistas comprometidos con tu bienestar
                </p>

                <div class="row g-4">
                    <!-- Doctor 1 -->
                    <div class="col-md-4">
                        <div class="doctor-card" onclick="showDoctorModal('Dr. Juan Pérez', 'Cardiología', 'Especialista en Cardiología con más de 15 años de experiencia en diagnóstico y tratamiento de enfermedades cardiovasculares. Graduado de la Universidad Nacional Mayor de San Marcos.')">
                            <img src="https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=300&fit=crop&crop=face" 
                                 alt="Dr. Juan Pérez" class="doctor-image">
                            <div class="doctor-info">
                                <h4 class="doctor-name">Dr. Juan Pérez</h4>
                                <p class="doctor-specialty">Cardiología</p>
                                <p class="doctor-description">
                                    Especialista en Cardiología con más de 15 años de experiencia en diagnóstico y tratamiento de enfermedades cardiovasculares.
                                </p>
                                <small class="text-muted">Última consulta: hace 2 horas</small>
                            </div>
                        </div>
                    </div>

                    <!-- Doctor 2 -->    
                    <div class="col-md-4">
                        <div class="doctor-card" onclick="showDoctorModal('Dra. María López', 'Pediatría', 'Pediatra enfocada en el cuidado integral de niños y adolescentes. Especialista en desarrollo infantil y vacunación. Graduada de la Universidad Peruana Cayetano Heredia.')">
                            <img src="https://pixel-p1.s3.sa-east-1.amazonaws.com/doctor/avatar/86ecc21c/86ecc21c-a82c-4fc5-bbc3-be346e7364dc_medium_square.jpg" 
                                 alt="Dra. María López" class="doctor-image">
                            <div class="doctor-info">
                                <h4 class="doctor-name">Dra. María López</h4>
                                <p class="doctor-specialty">Pediatría</p>
                                <p class="doctor-description">
                                    Pediatra enfocada en el cuidado integral de niños y adolescentes. Especialista en desarrollo infantil.
                                </p>
                                <small class="text-muted">Última consulta: ayer</small>
                            </div>
                        </div>
                    </div>

                    <!-- Doctor 3 -->
                    <div class="col-md-4">
                        <div class="doctor-card" onclick="showDoctorModal('Dr. Carlos Ramírez', 'Neurología', 'Neurólogo especialista en trastornos del sistema nervioso. Experto en diagnóstico y tratamiento de enfermedades neurológicas. Graduado de la Universidad Nacional Mayor de San Marcos.')">
                            <img src="https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=300&fit=crop&crop=face" 
                                 alt="Dr. Carlos Ramírez" class="doctor-image">
                            <div class="doctor-info">
                                <h4 class="doctor-name">Dr. Carlos Ramírez</h4>
                                <p class="doctor-specialty">Neurología</p>
                                <p class="doctor-description">
                                    Neurólogo especialista en trastornos del sistema nervioso y enfermedades neurológicas.
                                </p>
                                <small class="text-muted">Última consulta: hace 3 días</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección Teleconsulta -->
        <section id="teleconsulta" class="fade-in">
            <div class="container">
                <h2 class="section-title">Teleconsulta</h2>
                <p class="section-subtitle">
                    Inicia tu consulta médica en línea de forma rápida y segura
                </p>

                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="text-center p-5" style="background: linear-gradient(135deg, var(--color-principal), var(--color-secundario)); border-radius: 15px; color: white;">
                            <i class="fas fa-video fa-4x mb-4 pulse-animation"></i>
                            <h3 class="mb-3">¿Listo para tu consulta?</h3>
                            <p class="mb-4">Conéctate con nuestros especialistas desde la comodidad de tu hogar</p>
                            <button class="cta-secondary" onclick="showConsultaModal()" style="background: white; color: var(--color-principal); border: 2px solid white;">
                                <i class="fas fa-play-circle"></i>
                                Iniciar Videoconsulta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Sección Contacto -->
        <section id="contacto" class="fade-in" style="background: #f8f9fa;">
            <div class="container">
                <h2 class="section-title">Contacta con Nosotros</h2>
                <p class="section-subtitle">
                    Estamos aquí para ayudarte. Contáctanos a través de cualquiera de nuestros canales
                </p>

                <div class="row g-4">
                    <div class="col-md-6">
                        <div class="contact-info-card">
                            <h4><i class="fas fa-info-circle"></i> Información de Contacto</h4>
                            <div class="contact-items">
                                <div class="contact-item">
                                    <i class="fas fa-phone"></i>
                                    <div>
                                        <strong>Teléfono</strong>
                                        <p>+51 935 222 034</p>
                                    </div>
                                </div>

                                <div class="contact-item">
                                    <i class="fas fa-envelope"></i>
                                    <div>
                                        <strong>Email</strong>
                                        <p>info@telemedincinoperu.com</p>
                                    </div>
                                </div>

                                <div class="contact-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <div>
                                        <strong>Ubicación</strong>
                                        <p>Lima - Perú</p>
                                    </div>
                                </div>

                                <div class="contact-item">
                                    <i class="fas fa-clock"></i>
                                    <div>
                                        <strong>Horarios</strong>
                                        <p>Citas médicas con anticipación de 24 horas</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="contact-form-card">
                            <h4><i class="fas fa-envelope"></i> Envíanos un Mensaje</h4>
                            <form class="contact-form" onsubmit="handleContactForm(event)">
                                <div class="form-group">
                                    <input type="text" placeholder="Tu nombre completo" required>
                                </div>

                                <div class="form-group">
                                    <input type="email" placeholder="Tu email" required>
                                </div>

                                <div class="form-group">
                                    <input type="tel" placeholder="Tu teléfono">
                                </div>

                                <div class="form-group">
                                    <select required>
                                        <option value="">Selecciona un servicio</option>
                                        <option value="consulta">Consulta General</option>
                                        <option value="cardiologia">Cardiología</option>
                                        <option value="pediatria">Pediatría</option>
                                        <option value="neurologia">Neurología</option>
                                        <option value="otros">Otros</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <textarea placeholder="Cuéntanos cómo podemos ayudarte" required></textarea>
                                </div>

                                <button type="submit" class="submit-btn">
                                    <i class="fas fa-paper-plane"></i>
                                    Enviar Mensaje
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h4>TeleMed Perú</h4>
                        <p>Primera institución privada dedicada a la implementación de tecnologías para mejorar los servicios de salud.</p>
                        <div class="social-links mt-3">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#"><i class="fab fa-youtube"></i></a>
                            <a href="#"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>

                    <div class="footer-section">
                        <h4>Servicios</h4>
                        <ul>
                            <li><a href="#servicios">Consultas en Línea</a></li>
                            <li><a href="#servicios">Recetas Digitales</a></li>
                            <li><a href="#servicios">Telemonitoreo</a></li>
                            <li><a href="#doctores">Especialistas</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h4>Enlaces Rápidos</h4>
                        <ul>
                            <li><a href="#nosotros">Nosotros</a></li>
                            <li><a href="#doctores">Doctores</a></li>
                            <li><a href="#teleconsulta">Teleconsulta</a></li>
                            <li><a href="#contacto">Contacto</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h4>Contacto</h4>
                        <p><i class="fas fa-phone"></i> +51 935 222 034</p>
                        <p><i class="fas fa-envelope"></i> info@telemedincinoperu.com</p>
                        <p><i class="fas fa-map-marker-alt"></i> Lima - Perú</p>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2025 TeleMed Perú. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>

        <!-- Modales -->
       

        <!-- Modal Consulta -->
        <div class="modal fade" id="consultaModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-video"></i> Iniciar Teleconsulta</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Selecciona tu especialidad:</h6>
                                <div class="d-grid gap-2 mt-3">
                                    <button class="btn btn-outline-primary" onclick="selectSpecialty('Cardiología')">
                                        <i class="fas fa-heartbeat"></i> Cardiología
                                    </button>
                                    <button class="btn btn-outline-primary" onclick="selectSpecialty('Pediatría')">
                                        <i class="fas fa-baby"></i> Pediatría
                                    </button>
                                    <button class="btn btn-outline-primary" onclick="selectSpecialty('Neurología')">
                                        <i class="fas fa-brain"></i> Neurología
                                    </button>
                                    <button class="btn btn-outline-primary" onclick="selectSpecialty('Consulta General')">
                                        <i class="fas fa-user-md"></i> Consulta General
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6>Información de la consulta:</h6>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i>
                                    <strong>Recuerda:</strong>
                                    <ul class="mt-2 mb-0">
                                        <li>Ten tu documento de identidad listo</li>
                                        <li>Asegúrate de tener buena conexión</li>
                                        <li>Costo: S/ 50.00</li>
                                        <li>Duración: 30 minutos aprox.</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Feature Info -->
        <div class="modal fade" id="featureModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="featureModalTitle"></h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p id="featureModalContent"></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Doctor Info -->
        <div class="modal fade" id="doctorModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="doctorModalTitle"></h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>Especialidad:</strong> <span id="doctorModalSpecialty"></span></p>
                        <p id="doctorModalContent"></p>
                        <div class="text-center mt-3">
                            <button class="cta-primary" onclick="bookAppointment()">
                                <i class="fas fa-calendar-plus"></i> Agendar Consulta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notification -->
        <div id="notification" class="notification">
            <span id="notificationText"></span>
        </div>

        <script>
            // Variables globales
            let selectedSpecialty = '';

            // Función para mostrar notificaciones
            function showNotification(message, duration = 3000) {
                const notification = document.getElementById('notification');
                const notificationText = document.getElementById('notificationText');

                notificationText.textContent = message;
                notification.classList.add('show');

                setTimeout(() => {
                    notification.classList.remove('show');
                }, duration);
            }

            // Navbar scroll effect
            window.addEventListener('scroll', function () {
                const navbar = document.getElementById('mainNavbar');
                if (window.scrollY > 100) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }

                // Fade in animation
                document.querySelectorAll(".fade-in").forEach(el => {
                    const rect = el.getBoundingClientRect().top;
                    if (rect < window.innerHeight - 100) {
                        el.classList.add("show");
                    }
                });
            });

            // Navegación suave
            function scrollToSection(sectionId) {
                document.getElementById(sectionId).scrollIntoView({
                    behavior: 'smooth'
                });
            }

            // Establecer navegación activa
            function setActiveNav(element) {
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.classList.remove('active');
                });
                element.classList.add('active');
            }

          

            // Mostrar modal de consulta
            function showConsultaModal() {
                new bootstrap.Modal(document.getElementById('consultaModal')).show();
            }

            // Mostrar información de características
            function showFeatureModal(title, content) {
                document.getElementById('featureModalTitle').textContent = title;
                document.getElementById('featureModalContent').textContent = content;
                new bootstrap.Modal(document.getElementById('featureModal')).show();
            }

            // Mostrar información del doctor
            function showDoctorModal(name, specialty, description) {
                document.getElementById('doctorModalTitle').textContent = name;
                document.getElementById('doctorModalSpecialty').textContent = specialty;
                document.getElementById('doctorModalContent').textContent = description;
                new bootstrap.Modal(document.getElementById('doctorModal')).show();
            }

            // Seleccionar especialidad
            function selectSpecialty(specialty) {
                selectedSpecialty = specialty;
                showNotification(`Especialidad seleccionada: ${specialty}`);

                setTimeout(() => {
                    bootstrap.Modal.getInstance(document.getElementById('consultaModal')).hide();
                    setTimeout(() => {
                        showNotification('Redirigiendo a la plataforma de videoconsulta...', 2000);
                    }, 500);
                }, 1000);
            }

            // Agendar cita
            function bookAppointment() {
                showNotification('Redirigiendo al sistema de citas...');
                bootstrap.Modal.getInstance(document.getElementById('doctorModal')).hide();
            }

         

            // Manejar formulario de contacto
            function handleContactForm(event) {
                event.preventDefault();
                showNotification('Enviando mensaje...', 2000);

                setTimeout(() => {
                    showNotification('¡Mensaje enviado correctamente! Te contactaremos pronto.', 4000);
                    event.target.reset();
                }, 2000);
            }

            // Intersección observer para animaciones
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('show');
                    }
                });
            }, observerOptions);

            // Observar elementos con fade-in
            document.addEventListener('DOMContentLoaded', () => {
                document.querySelectorAll('.fade-in').forEach(el => {
                    observer.observe(el);
                });

                // Mostrar notificación de bienvenida
                setTimeout(() => {
                    showNotification('¡Bienvenido a TeleMed Perú!', 3000);
                }, 1000);
            });

            // Efectos de teclado
            document.addEventListener('keydown', (e) => {
                if (e.key === 'Escape') {
                    // Cerrar modales con Escape
                    const modals = document.querySelectorAll('.modal.show');
                    modals.forEach(modal => {
                        bootstrap.Modal.getInstance(modal)?.hide();
                    });
                }
            });
        </script>
    </body>
</html>