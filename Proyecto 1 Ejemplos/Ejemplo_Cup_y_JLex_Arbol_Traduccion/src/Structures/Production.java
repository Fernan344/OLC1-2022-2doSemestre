/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Structures;

import Structures.Instructions.Instruccion;
import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class Production {
    private Node nodo;
    private Instruccion ins;
    private LinkedList<Instruccion> instructions;

    public Production() {
    }    

    public Production(Node nodo, Instruccion ins) {
        this.nodo = nodo;
        this.ins = ins;
    }
    
    public Production(Node nodo, LinkedList<Instruccion> ins) {
        this.nodo = nodo;
        this.instructions = ins;
    }

    public LinkedList<Instruccion> getInstructions() {
        return instructions;
    }

    public void setInstructions(LinkedList<Instruccion> instructions) {
        this.instructions = instructions;
    }   
    
    public void addIns(Instruccion ins){
        this.instructions.add(ins);
    }

    public void addSon(String valor){
        this.nodo.addSon(valor);
    }
    
    public void addSon(Production valor){
        this.nodo.addSon(valor.getNode());
    }
    
    public Node getNode() {
        return nodo;
    }

    public void setNodo(Node nodo) {
        this.nodo = nodo;
    }

    public Instruccion getIns() {
        return ins;
    }

    public void setIns(Instruccion ins) {
        this.ins = ins;
    }
    
    
}
