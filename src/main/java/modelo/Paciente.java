package modelo;

import java.math.BigDecimal;

public class Paciente {
    private int idPaciente;
    private int idUsuario; // FK hacia Usuario
    private String historialClinico;
    private String alergias;
    private String grupoSanguineo; // A+, A-, B+, etc.
    private BigDecimal peso; // kg
    private BigDecimal altura; // m

    //FOTO
    private byte[] fotoPerfil;
    
    // Datos del usuario
    private String nombre;
    private String apellido;
    private String correo;
    private String telefono;
    private String estado;
    private String info;

    public Paciente() {}
    public Paciente(int idUsuario, String tipoSangre, String alergias) {
    this.idUsuario = idUsuario;
    this.grupoSanguineo = tipoSangre;
    this.alergias = alergias;
}
   public Paciente(int idUsuario, String historialClinico, String alergias, String grupoSanguineo,
                BigDecimal peso, BigDecimal altura) {
    this.idUsuario = idUsuario;
    this.historialClinico = historialClinico;
    this.alergias = alergias;
    this.grupoSanguineo = grupoSanguineo;
    this.peso = peso;
    this.altura = altura;
}

    // Getters y Setters
    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getHistorialClinico() { return historialClinico; }
    public void setHistorialClinico(String historialClinico) { this.historialClinico = historialClinico; }

    public String getAlergias() { return alergias; }
    public void setAlergias(String alergias) { this.alergias = alergias; }

    public String getGrupoSanguineo() { return grupoSanguineo; }
    public void setGrupoSanguineo(String grupoSanguineo) { this.grupoSanguineo = grupoSanguineo; }

    public BigDecimal getPeso() { return peso; }
    public void setPeso(BigDecimal peso) { this.peso = peso; }

    public BigDecimal getAltura() { return altura; }
    public void setAltura(BigDecimal altura) { this.altura = altura; }
    

    // Datos del usuario
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    
    public String getEstado() {return estado;}
    public void setEstado(String estado) {this.estado = estado;}

    public String getInfo() {return info;}
    public void setInfo(String info) {this.info = info;}
}
