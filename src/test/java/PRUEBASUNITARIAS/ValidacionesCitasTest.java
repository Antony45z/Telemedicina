/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/UnitTests/JUnit5TestClass.java to edit this template
 */
package PRUEBASUNITARIAS;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author anton
 */
public class ValidacionesCitasTest {
    
    public ValidacionesCitasTest() {
    }
    
    @BeforeAll
    public static void setUpClass() {
    }
    
    @AfterAll
    public static void tearDownClass() {
    }
    
    @BeforeEach
    public void setUp() {
    }
    
    @AfterEach
    public void tearDown() {
    }

    /**
     * Test of esIdCitaValido method, of class ValidacionesCitas.
     */
    @Test
    public void testEsIdCitaValido() {
        System.out.println("esIdCitaValido");
        String idCitaStr = "2";
        ValidacionesCitas instance = new ValidacionesCitas();
        boolean expResult = true;
        boolean result = instance.esIdCitaValido(idCitaStr);
        System.out.println(expResult);
        System.out.println(result);
        if(expResult != result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
        
    }

    /**
     * Test of obtenerUrlRedireccion method, of class ValidacionesCitas.
     */
    @Test
    public void testObtenerUrlRedireccion() {
        System.out.println("obtenerUrlRedireccion");
        boolean fueExitoso = true;
        ValidacionesCitas instance = new ValidacionesCitas();
        String expResult = "AdministracionCita?mensaje=actualizado_ok";
        String result = instance.obtenerUrlRedireccion(fueExitoso);
        System.out.println(expResult);
        System.out.println(result);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
