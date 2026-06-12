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
public class ValidacionesRegistroTest {
    
    public ValidacionesRegistroTest() {
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
     * Test of determinarFlujoPorRol method, of class ValidacionesRegistro.
     */
    @Test
    public void testDeterminarFlujoPorRol() {
        System.out.println("determinarFlujoPorRol");
        String rol = "MEDICO";
        ValidacionesRegistro instance = new ValidacionesRegistro();
        String expResult = "PROCESAR_DETALLE_MEDICO";
        String result = instance.determinarFlujoPorRol(rol);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of evaluarAniosExperiencia method, of class ValidacionesRegistro.
     */
    @Test
    public void testEvaluarAniosExperiencia() {
        System.out.println("evaluarAniosExperiencia");
        String experienciaStr = "";
        ValidacionesRegistro instance = new ValidacionesRegistro();
        int expResult = 0;
        int result = instance.evaluarAniosExperiencia(experienciaStr);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of puedeContinuarConDetalles method, of class ValidacionesRegistro.
     */
    @Test
    public void testPuedeContinuarConDetalles() {
        System.out.println("puedeContinuarConDetalles");
        int idUsuario = 7;
        ValidacionesRegistro instance = new ValidacionesRegistro();
        boolean expResult = true;
        boolean result = instance.puedeContinuarConDetalles(idUsuario);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
