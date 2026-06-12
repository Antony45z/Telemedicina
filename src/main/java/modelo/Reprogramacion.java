/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.Timestamp;

/**
 *
 * @author anton
 */
public class Reprogramacion {
    
    private Timestamp fechaAnterior;
    private Timestamp fechaNueva;
    private String motivo;
    private String realizadoPor;
    private Timestamp fechaAccion;
    public Reprogramacion()
    {
        
    }
    public Reprogramacion(Timestamp fechaAnterior, Timestamp fechaNueva, String motivo, String realizadoPor, Timestamp fechaAccion) {
        this.fechaAnterior = fechaAnterior;
        this.fechaNueva = fechaNueva;
        this.motivo = motivo;
        this.realizadoPor = realizadoPor;
        this.fechaAccion = fechaAccion;
    }
    
    public Timestamp getFechaAnterior() {
        return fechaAnterior;
    }

    public void setFechaAnterior(Timestamp fechaAnterior) {
        this.fechaAnterior = fechaAnterior;
    }

    public Timestamp getFechaNueva() {
        return fechaNueva;
    }

    public void setFechaNueva(Timestamp fechaNueva) {
        this.fechaNueva = fechaNueva;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getRealizadoPor() {
        return realizadoPor;
    }

    public void setRealizadoPor(String realizadoPor) {
        this.realizadoPor = realizadoPor;
    }

    public Timestamp getFechaAccion() {
        return fechaAccion;
    }

    public void setFechaAccion(Timestamp fechaAccion) {
        this.fechaAccion = fechaAccion;
    }
    
}
