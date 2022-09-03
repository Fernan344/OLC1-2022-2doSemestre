/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Structures.Instructions;

/**
 *
 * @author teval
 */

public class Evaluar implements Instruccion{
    
    private Operacion valor;

    public Evaluar(Operacion valor) {
        this.valor = valor;
    }   

    @Override
    public String traducir() {
        return "estamos evaluando (" + valor.traducir() + ")\n";
    }
    
}