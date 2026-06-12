# Paso 1: Usamos Maven para compilar el proyecto
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Paso 2: Usamos Tomcat 10 que sí soporta Jakarta EE 10
FROM tomcat:10.1-jdk17-temurin-jammy
# Limpiamos las aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*
# Copiamos nuestro archivo .war generado en el paso anterior como la app principal (ROOT)
COPY --from=build /app/target/Telemedicina-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]