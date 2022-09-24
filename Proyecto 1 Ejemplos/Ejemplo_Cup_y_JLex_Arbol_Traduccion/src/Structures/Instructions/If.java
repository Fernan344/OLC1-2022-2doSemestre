/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Structures.Instructions;

import static Utils.Analizador.getIdentacion;
import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class If implements Instruccion{
    /**
     * Condición de la instrucción si..entonces.
     */
    private final Operacion condicion;
    /**
     * Lista de instrucciones que serán ejecutadas si la condición se cumple.
     */
    private final LinkedList<Instruccion> listaInstrucciones;
    /**
     * Lista de instrucciones que serán ejecutadas si la condición ELSE IF se cumple.
     */
    private LinkedList<Instruccion> listaElseIfInstrucciones;
    /**
     * Lista de instrucciones que se ejecutarán si la condición no se cumple,
     * esta lista existirá solo si la instrucción posee la clausula ELSE, de lo
     * contrario la lista será null.
     */
    private LinkedList<Instruccion> listaInsElse;
    /**
     * Primer constructor de la clase, este se utiliza cuando la instrucción no 
     * tiene clausula ELSE.
     * @param a Condición del si..entonces
     * @param b Lista de instrucciones que deberían ejecutarse si la condición se cumple
     */
    public If(Operacion a, LinkedList<Instruccion> b) {
        condicion=a;
        listaInstrucciones=b;
    }
    /**
     * Segundo constructor de la clase, este se utiliza cuando la instrucción tiene
     * clausula ELSE.
     * @param a Condición del si..entonces
     * @param b Lista de instrucciones que deberían ejecutarse si la condición se cumple
     * @param c Lista de instrucciones que deberían ejecutarse si la condición no se cumple
     */
    public If(Operacion a, LinkedList<Instruccion> b, LinkedList<Instruccion> c) {
        condicion=a;
        listaInstrucciones=b;
        listaInsElse=c;
    }
    /**
     * Tercer constructor de la clase, este se utiliza cuando la instrucción tiene
     * clausula IF (ELSE IF/ ELSE).
     * @param a Condición del si..entonces
     * @param b Lista de instrucciones que deberían ejecutarse si la condición se cumple
     * @param l Lista de instrucciones que deberían ejecutarse si la condición ElSE IF se cumple
     * @param c Lista de instrucciones que deberían ejecutarse si la condición no se cumple
     */
    public If(Operacion a, LinkedList<Instruccion> b, LinkedList<Instruccion> l, LinkedList<Instruccion> c) {
        condicion=a;
        listaInstrucciones=b;
        listaElseIfInstrucciones = l;
        listaInsElse=c;
    }
    /**
     * Método que ejecuta la instrucción si..entonces, es una sobreescritura del 
     * método ejecutar que se debe programar por la implementación de la interfaz
     * instrucción
     * @param ts tabla de símbolos del ámbito padre de la sentencia.
     * @return Estra instrucción retorna nulo porque no produce ningún valor en 
     * su ejecución
     */
    @Override
    public String traducir(int identacion) {
        
        String traduccion = Utils.Analizador.getIdentacion(identacion) + "Este es un IF para la OP "+this.condicion.traducir(identacion)+":\n";
        if(listaInstrucciones != null)
            for(Instruccion ins: listaInstrucciones){
                traduccion += Utils.Analizador.getIdentacion(identacion + 1) + ins.traducir(identacion+1);
            }
        if(listaElseIfInstrucciones != null){
            traduccion += Utils.Analizador.getIdentacion(identacion) + "Si no se cumple entonces ";
            for(Instruccion ins: listaElseIfInstrucciones){
                traduccion += Utils.Analizador.getIdentacion(identacion) + ins.traducir(identacion);
            }
        }
        if(listaInsElse != null){
            traduccion += Utils.Analizador.getIdentacion(identacion) + "Si ninguna se cumple entonces: \n";
            for(Instruccion ins: listaInsElse){
                traduccion += Utils.Analizador.getIdentacion(identacion + 1) + ins.traducir(identacion+1);
            }
        }
        return traduccion;
    }
}
