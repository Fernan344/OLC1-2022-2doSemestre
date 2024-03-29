/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import Structures.Arbol;
import Structures.Instructions.Instruccion;
import java.io.File;
import java.io.FileInputStream;
import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class Analizador {
    
    private LinkedList<Instruccion> AST_arbolSintaxisAbstracta;
    private Arbol arbol;

    public Analizador() {
    }
    
    public String interpretar(String text) {
        File file = new File("./public/parse.txt");  
        (new Files()).crearArchivo(file, text);
        analizadores.Sintactico pars;
        try {
            pars=new analizadores.Sintactico(new analizadores.Lexico(new FileInputStream(file)));
            pars.parse();        
            AST_arbolSintaxisAbstracta=pars.getAST();
            arbol = pars.getArbol();
        } catch (Exception ex) {
            System.out.println("Error fatal en compilación de entrada.");
            System.out.println("Causa: "+ex);
        } 
        return ejecutarAST(AST_arbolSintaxisAbstracta);
    }
    
    public Arbol getArbol(){
        return this.arbol;
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
        int identacion = 0;
        for(Instruccion ins:ast){
            //Si existe un error léxico o sintáctico en cierta instrucción esta
            //será inválida y se cargará como null, por lo tanto no deberá ejecutarse
            //es por esto que se hace esta validación.
            if(ins!=null)
                traduccion += getIdentacion(identacion)+ins.traducir(identacion);
        }
        
        return traduccion;
    }
    
    public static String getIdentacion(int identacion) {
        String identacionTraduct = "";
        for (int i=0; i<identacion; i++){
            identacionTraduct += "              ";
        }
        return identacionTraduct;
    }
}
