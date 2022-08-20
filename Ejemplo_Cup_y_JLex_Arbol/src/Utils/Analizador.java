/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import Structures.Instructions.Instruccion;
import java.io.File;
import java.io.FileInputStream;
import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class Analizador {

    public Analizador() {
    }
    
    public String interpretar(String text) {
        File file = new File("./public/parse.txt");  
        (new Files()).crearArchivo(file, text);
        analizadores.Sintactico pars;
        LinkedList<Instruccion> AST_arbolSintaxisAbstracta=null;
        try {
            pars=new analizadores.Sintactico(new analizadores.Lexico(new FileInputStream(file)));
            pars.parse();        
            AST_arbolSintaxisAbstracta=pars.getAST();
        } catch (Exception ex) {
            System.out.println("Error fatal en compilación de entrada.");
            System.out.println("Causa: "+ex);
        } 
        return ejecutarAST(AST_arbolSintaxisAbstracta);
    }
    
    public String ejecutarAST(LinkedList<Instruccion> ast) {
        if(ast==null){
            return("No es posible ejecutar las instrucciones porque\r\n"
                    + "el árbol no fue cargado de forma adecuada por la existencia\r\n"
                    + "de errores léxicos o sintácticos.");
        }
        //Se ejecuta cada instruccion en el ast, es decir, cada instruccion de 
        //la lista principal de instrucciones.
        
        String traduccion = "";
        
        for(Instruccion ins:ast){
            //Si existe un error léxico o sintáctico en cierta instrucción esta
            //será inválida y se cargará como null, por lo tanto no deberá ejecutarse
            //es por esto que se hace esta validación.
            if(ins!=null)
                traduccion += ins.traducir();
        }
        
        return traduccion;
    }
}
