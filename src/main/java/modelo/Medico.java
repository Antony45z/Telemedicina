package modelo;

public class Medico {
    private int idMedico;
    private int idUsuario; // FK hacia Usuario
    private String nroColegiatura;
    private String especialidad;
    private int aniosExperiencia;
    private String centroLaboral;
    private String descripcion;
    

    // Datos de usuario (JOIN con tabla usuarios)
    private String nombre;
    private String apellido;
    private String correo;
    private String telefono;
    private byte[] fotoPerfil;
    private String estado;
    private String info;
    

    // Constructor vacío
    public Medico() {}

    // Constructor para insertar
    public Medico(int idUsuario, String nroColegiatura, String especialidad, int aniosExperiencia,
                  String centroLaboral, String descripcion) {
        this.idUsuario = idUsuario;
        this.nroColegiatura = nroColegiatura;
        this.especialidad = especialidad;
        this.aniosExperiencia = aniosExperiencia;
        this.centroLaboral = centroLaboral;
        this.descripcion = descripcion;
    }

    // Constructor para listar o mostrar datos completos
    public Medico(int idMedico, int idUsuario, String nroColegiatura, String especialidad,
                  int aniosExperiencia, String centroLaboral, String descripcion,
                  String nombre, String apellido, String correo, String telefono, byte[] fotoPerfil, String estado, String info) {
        this.idMedico = idMedico;
        this.idUsuario = idUsuario;
        this.nroColegiatura = nroColegiatura;
        this.especialidad = especialidad;
        this.aniosExperiencia = aniosExperiencia;
        this.centroLaboral = centroLaboral;
        this.descripcion = descripcion;
        this.nombre = nombre;
        this.apellido = apellido;
        this.correo = correo;
        this.telefono = telefono;
        this.fotoPerfil = fotoPerfil;
        this.estado=estado;
        this.info=info; 
    }

    // Getters y Setters
    public int getIdMedico() { return idMedico; }
    public void setIdMedico(int idMedico) { this.idMedico = idMedico; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNroColegiatura() { return nroColegiatura; }
    public void setNroColegiatura(String nroColegiatura) { this.nroColegiatura = nroColegiatura; }

    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }

    public int getAniosExperiencia() { return aniosExperiencia; }
    public void setAniosExperiencia(int aniosExperiencia) { this.aniosExperiencia = aniosExperiencia; }

    public String getCentroLaboral() { return centroLaboral; }
    public void setCentroLaboral(String centroLaboral) { this.centroLaboral = centroLaboral; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    public void setDireccion(String direccion) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setPassword(String password) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
    
    public byte[] getFotoPerfil() {
    return fotoPerfil;
    }

    public void setFotoPerfil(byte[] fotoPerfil) {
    this.fotoPerfil = fotoPerfil;
    }
    public String getEstado() {
    return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
    public String getInfo() {
    return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }
}
