package modelo;

import java.sql.Timestamp;

public class Publicacion {
    private int idPublicacion;
    private int idMedico;
    private Integer idCategoria; // puede ser null si la categoría se elimina
    private String titulo;
    private String contenido;
    private Timestamp fechaPublicacion;
    // campos adicionales
    private String nombreCategoria;
    private String nombreMedico;

    //CUADRA AGREGO ESTO
    private byte[] fotoMedico;
    
    // Constructor vacío
    public Publicacion() {}

    // Constructor con parámetros
    public Publicacion(int idPublicacion, int idMedico, Integer idCategoria, String titulo, String contenido, Timestamp fechaPublicacion) {
        this.idPublicacion = idPublicacion;
        this.idMedico = idMedico;
        this.idCategoria = idCategoria;
        this.titulo = titulo;
        this.contenido = contenido;
        this.fechaPublicacion = fechaPublicacion;
    }

    // Getters y Setters
    public int getIdPublicacion() {
        return idPublicacion;
    }

    public void setIdPublicacion(int idPublicacion) {
        this.idPublicacion = idPublicacion;
    }

    public int getIdMedico() {
        return idMedico;
    }

    public void setIdMedico(int idMedico) {
        this.idMedico = idMedico;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public Timestamp getFechaPublicacion() {
        return fechaPublicacion;
    }

    public void setFechaPublicacion(Timestamp fechaPublicacion) {
        this.fechaPublicacion = fechaPublicacion;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    public String getNombreMedico() {
        return nombreMedico;
    }

    public void setNombreMedico(String nombreMedico) {
        this.nombreMedico = nombreMedico;
    }
    public byte[] getFotoMedico() {
        return fotoMedico;
    }

    public void setFotoMedico(byte[] fotoMedico) {
        this.fotoMedico = fotoMedico;
    }
}
