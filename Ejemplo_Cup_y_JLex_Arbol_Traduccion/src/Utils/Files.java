/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author teval
 */
public class Files {

    public Files() {
    }
    
    public String readFile(File archivo){
        try {
            Scanner obj = new Scanner(archivo);
            String entrada = "";
            while (obj.hasNextLine()){
                entrada+=obj.nextLine()+'\n';                
            }
            return entrada;
        } catch (FileNotFoundException ex) {
            return "Error Archivo invalido.";
        }  
    }
    
    public void crearArchivo(File file, String contenido){
        if(!file.exists()){
            try {
                file.createNewFile();
            } catch (IOException ex) {
                Logger.getLogger(Files.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        FileWriter fichero = null;
        PrintWriter pw = null;
        
        try
        {
            fichero = new FileWriter(file);
            pw = new PrintWriter(fichero);
            String [] lineas = contenido.split("\n");

            for (String linea: lineas)
                pw.println(linea);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
           try {           // Nuevamente aprovechamos el finally para 
           // asegurarnos que se cierra el fichero.
            if (null != fichero)
               fichero.close();
           } catch (Exception e2) {
              e2.printStackTrace();
           }
        }
    }
}
