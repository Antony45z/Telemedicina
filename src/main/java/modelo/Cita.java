package modelo;

import java.util.Date;
import java.util.List;

public class Cita {
    private int idCita;           // id_cita
    private String ticket;        // ticket
    private int idPaciente;       // id_paciente
    private int idMedico;         // id_medico
    private Date fechaCita;       // fecha_cita
    private String motivo;        // motivo
    private String estado;        // estado
    private Date fechaRegistro;   // fecha_registro
    private Date horaFin;         // hora_fin
    private String nombreMedico;
    private String especialidadMedico;
    private String descripcionDiagnostico;
    private String recetaDiagnostico;
    private String tratamiento; //nuevo
    private List<Reprogramacion> reprogramaciones;
    private List<Cancelacion> cancelaciones;

    public List<Reprogramacion> getReprogramaciones() {
        return reprogramaciones;
    }

    public void setReprogramaciones(List<Reprogramacion> reprogramaciones) {
        this.reprogramaciones = reprogramaciones;
    }

    public List<Cancelacion> getCancelaciones() {
        return cancelaciones;
    }

    public void setCancelaciones(List<Cancelacion> cancelaciones) {
        this.cancelaciones = cancelaciones;
    }
    


public String getDescripcionDiagnostico() { return descripcionDiagnostico; }
public void setDescripcionDiagnostico(String d) { this.descripcionDiagnostico = d; }

public String getRecetaDiagnostico() { return recetaDiagnostico; }
public void setRecetaDiagnostico(String r) { this.recetaDiagnostico = r; }

public String getTratamiento() { return tratamiento; } //nuevo
public void setTratamiento(String tratamiento) { this.tratamiento= tratamiento; }


public String getNombreMedico() { return nombreMedico; }
public void setNombreMedico(String nombreMedico) { this.nombreMedico = nombreMedico; }

public String getEspecialidadMedico() { return especialidadMedico; }
public void setEspecialidadMedico(String especialidadMedico) { this.especialidadMedico = especialidadMedico; }
    // Constructor vacío
    public Cita() {
    }

    // Constructor completo
    public Cita(int idCita, String ticket, int idPaciente, int idMedico, Date fechaCita,
                String motivo, String estado, Date fechaRegistro, Date horaFin) {
        this.idCita = idCita;
        this.ticket = ticket;
        this.idPaciente = idPaciente;
        this.idMedico = idMedico;
        this.fechaCita = fechaCita;
        this.motivo = motivo;
        this.estado = estado;
        this.fechaRegistro = fechaRegistro;
        this.horaFin = horaFin;
    }

    // Getters y Setters
    public int getIdCita() {
        return idCita;
    }

    public void setIdCita(int idCita) {
        this.idCita = idCita;
    }

    public String getTicket() {
        return ticket;
    }

    public void setTicket(String ticket) {
        this.ticket = ticket;
    }

    public int getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(int idPaciente) {
        this.idPaciente = idPaciente;
    }

    public int getIdMedico() {
        return idMedico;
    }

    public void setIdMedico(int idMedico) {
        this.idMedico = idMedico;
    }

    public Date getFechaCita() {
        return fechaCita;
    }

    public void setFechaCita(Date fechaCita) {
        this.fechaCita = fechaCita;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
      public Date getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(Date horaFin) {
        this.horaFin = horaFin;
    }

}
