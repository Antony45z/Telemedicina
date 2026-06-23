# Paso 1: Usamos Maven para compilar el proyecto
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Paso 2: Usamos Tomcat 10 que soporta Jakarta EE 10
FROM tomcat:10.1-jdk17-temurin-jammy

# Copiamos nuestro archivo .war directamente reemplazando el ROOT.war
COPY --from=build /app/target/Telemedicina-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# IMPORTANTE: Forzamos a Tomcat a escuchar en el puerto que Railway le asigne en tiempo real
CMD ["sh", "-c", "sed -i 's/port=\"8080\"/port=\"'${PORT:-8080}'\"/g' /usr/local/tomcat/conf/server.xml && catalina.sh run"]
