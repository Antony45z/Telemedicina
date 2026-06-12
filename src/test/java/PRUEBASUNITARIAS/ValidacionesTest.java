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
public class ValidacionesTest {
    
    public ValidacionesTest() {
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
     * Test of esIdValidoParaEliminar method, of class Validaciones.
     */
    @Test
    public void testEsIdValidoParaEliminar() {
        System.out.println("esIdValidoParaEliminar");
        String idTexto = "1";
        Validaciones instance = new Validaciones();
        boolean expResult = true;
        boolean result = instance.esIdValidoParaEliminar(idTexto);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of corregirIdCategoria method, of class Validaciones.
     */
    @Test
    public void testCorregirIdCategoria() {
        System.out.println("corregirIdCategoria");
        String categoriaStr = "4";
        Validaciones instance = new Validaciones();
        int expResult = 4;
        int result = instance.corregirIdCategoria(categoriaStr);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult != result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of estanCamposCompletos method, of class Validaciones.
     */
    @Test
    public void testEstanCamposCompletos() {
        System.out.println("estanCamposCompletos");
        String titulo = "Infusión de jengibre para aliviar la tos";
        String contenido = "Hervir trozos de jengibre con limón, ayuda a descongestionar y reducir la irritación de garganta.";
        Validaciones instance = new Validaciones();
        boolean expResult = true;
        boolean result = instance.estanCamposCompletos(titulo, contenido);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of determinarAccionGuardar method, of class Validaciones.
     */
    @Test
    public void testDeterminarAccionGuardar() {
        System.out.println("determinarAccionGuardar");
        boolean actualizar = true;
        Validaciones instance = new Validaciones();
        String expResult = "EDITAR_REGISTRO";
        String result = instance.determinarAccionGuardar(actualizar);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of validarAccionServlet method, of class Validaciones.
     */
    @Test
    public void testValidarAccionServlet() {
        System.out.println("validarAccionServlet");
        String accion = "registrar";
        Validaciones instance = new Validaciones();
        String expResult = "PROCESAR_REGISTRO";
        String result = instance.validarAccionServlet(accion);
        System.out.println(result);
        System.out.println(expResult);
        if(expResult!= result)
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
