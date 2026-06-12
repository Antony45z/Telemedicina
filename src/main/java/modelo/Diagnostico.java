package modelo;

import java.sql.Timestamp;

public class Diagnostico {
    private int idDiagnostico;
    private int idCita;
    private String descripcion;
    private String receta;
    private Timestamp fechaRegistro;
    private String ticket; // 🔹 Nuevo campo
    private String tratamiento; //Nuevo campo
    // Constructor vacío
    public Diagnostico() {}

    // Getters y setters
    public int getIdDiagnostico() { return idDiagnostico; }
    public void setIdDiagnostico(int idDiagnostico) { this.idDiagnostico = idDiagnostico; }

    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getReceta() { return receta; }
    public void setReceta(String receta) { this.receta = receta; }

    public Timestamp getFechaRegistro() { return fechaRegistro; }
    public void setFechaRegistro(Timestamp fechaRegistro) { this.fechaRegistro = fechaRegistro; }

    public String getTicket() { return ticket; } // 🔹 Getter del nuevo campo
    public void setTicket(String ticket) { this.ticket = ticket; } // 🔹 Setter del nuevo campo
    
    public String getTratamiento(){return tratamiento;} // nuevo
    public void setTratamiento(String tratamiento){this.tratamiento=tratamiento;}
}
