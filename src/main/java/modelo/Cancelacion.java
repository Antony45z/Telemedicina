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
public class Cancelacion {
    
    private String motivo;
    private String realizadoPor;
    private Timestamp fechaCancelacion;
    
    public Cancelacion(){}
    
    public Cancelacion(String motivo, String realizadoPor, Timestamp fechaCancelacion) {
        this.motivo = motivo;
        this.realizadoPor = realizadoPor;
        this.fechaCancelacion = fechaCancelacion;
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

    public Timestamp getFechaCancelacion() {
        return fechaCancelacion;
    }

    public void setFechaCancelacion(Timestamp fechaCancelacion) {
        this.fechaCancelacion = fechaCancelacion;
    }
}
