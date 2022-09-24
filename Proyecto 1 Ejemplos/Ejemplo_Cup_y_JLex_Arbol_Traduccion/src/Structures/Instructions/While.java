/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Structures.Instructions;

import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class While implements Instruccion{
    /**
     * Condición de la sentencia mientras.
     */
    private final Operacion condicion;
    /**
     * Lista de las instrucciones que deben ejecutarse si la condición se cumple.
     */
    private final LinkedList<Instruccion> listaInstrucciones;
    /**
     * Constructor de la clase Mientras
     * @param a condición que debe evaluarse para ejecutar el ciclo
     * @param b instrucciones que deben ejecutarse si la condición se cumpliera
     */
    public While(Operacion a, LinkedList<Instruccion> b) {
        this.condicion=a;
        this.listaInstrucciones=b;
    }
    /**
     * Método que ejecuta la instrucción mientras, es una sobreescritura del 
     * método ejecutar que se debe programar por la implementación de la interfaz
     * instrucción
     * @param ts tabla de símbolos del ámbito padre de la sentencia
     * @return Esta instrucción retorna nulo porque no produce ningun valor
     */
    @Override
    public String traducir(int identacion) {
        String traduccion = Utils.Analizador.getIdentacion(identacion) + "Mientras esta condicion se cumpla "+condicion.traducir(identacion)+" tenemos que hacer:\n";
        for(Instruccion ins:listaInstrucciones){
            traduccion += Utils.Analizador.getIdentacion(identacion + 1) + ins.traducir(identacion+1);
        }
        return traduccion;
    }   
}