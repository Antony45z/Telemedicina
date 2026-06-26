<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Telemed</title>
    <link rel="stylesheet" href="estilo/estilo.css">
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.2.0/crypto-js.min.js"></script>
    <style>

        .popup-error {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #ff4d4d;
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: bold;
            box-shadow: 0px 4px 10px rgba(0,0,0,0.2);
            z-index: 9999;
            animation: aparecer 0.3s ease;
        }

        @keyframes aparecer {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

    </style>
</head>

<body>

    <%-- ALERTA DE REGISTRO EXITOSO --%>
    <%
        if (session != null) {

            String mensajeExito =
                    (String) session.getAttribute("mensajeExito");

            if (mensajeExito != null) {
    %>

    <script>
        alert("<%= mensajeExito %>");
    </script>

    <%
                session.removeAttribute("mensajeExito");
            }
        }
    %>

    <%-- POPUP ERROR LOGIN --%>
    <%
        String error = (String) request.getAttribute("error");

        if(error != null){
    %>

        <div class="popup-error" id="popupError">
            <%= error %>
        </div>

        <script>

            // DESAPARECE SOLO
            setTimeout(() => {

                const popup = document.getElementById("popupError");

                if(popup){
                    popup.style.display = "none";
                }

            }, 4000);

        </script>

    <%
        }
    %>

    <div class="fondo">

        <div class="overlay"></div>

        <div class="login-caja">

            <h2>Inicia Sesión</h2>

            <form action="SvLogin" method="post">

                <input type="email"
                    name="correo"
                    id="correo"
                    placeholder="Correo electrónico"
                    required
                    maxlength="100"
                    pattern="^[A-Za-z0-9+_.\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"
                    title="Ingrese un correo válido">
                 <input type="password"
                        id="password"
                        placeholder="Contraseña"
                        required
                        minlength="8"
                        maxlength="45"
                        pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_]).{8,45}$"
                        title="La contraseña debe tener mayúscula, minúscula, número y símbolo">
                 
                <input type="hidden"
                       name="password"
                       id="passwordCifrada">
                <div class="g-recaptcha"
         data-sitekey="6Lcms-ssAAAAABhjtOVndSvloUl5EWxvcZ0KUmlk
"></div>
                <button type="submit">
                    Entrar
                </button>

            </form>

            <a href="registro.jsp">
                ¿No tienes cuenta? Regístrate
            </a>

        </div>

    </div>
<script>

    const form = document.querySelector("form");

    form.addEventListener("submit", function(e){

        const correo =
            document.getElementById("correo").value.trim();

        const password =
            document.getElementById("password").value.trim();

        // REGEX CORREO
        const regexCorreo =
            /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

        // REGEX PASSWORD
        const regexPassword =
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_]).{8,45}$/;

        if(!regexCorreo.test(correo)){

            e.preventDefault();

            alert(
                "El correo electrónico no tiene un formato válido."
            );

            return;
        }

        if(!regexPassword.test(password)){

            e.preventDefault();

            alert(
                "La contraseña debe tener entre 8 y 45 caracteres, incluyendo mayúscula, minúscula, número y símbolo."
            );

            return;
        }
                const claveAES = CryptoJS.enc.Utf8.parse("Telemed2026Clave");

const iv = CryptoJS.enc.Utf8.parse("1234567890123456");


const cifrado = CryptoJS.AES.encrypt(
    password,
    claveAES,
    {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    }
);


const passwordCifrada =
    cifrado.ciphertext.toString(CryptoJS.enc.Base64);


console.log("Original:", password);
console.log("Cifrada:", passwordCifrada);


document.getElementById("passwordCifrada").value =
    passwordCifrada;


document.getElementById("password").value = "";

});

</script>
</body>
</html>