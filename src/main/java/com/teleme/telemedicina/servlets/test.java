/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.teleme.telemedicina.servlets;

/**
 *
 * @author anton
 */
import dao.Conexion;
import dao.UsuarioDAO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import modelo.Usuario;

public class test
        {
public static void main(String[] args)
{
    try {
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://127.0.0.1:3306/telemedicina",
                "root",
                ""
            );
            System.out.println("CONECTADO OK");
        } catch (Exception e) {
            e.printStackTrace();
        }
}
}
