/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Structures;

import java.util.LinkedList;

/**
 *
 * @author teval
 */
public class Node {
    private LinkedList<Node> hijos;

    public Node() {
    }
    
    public Node(LinkedList<Node> hijos) {
        this.hijos = hijos;
    }

    public LinkedList<Node> getHijos() {
        return hijos;
    }

    public void setHijos(LinkedList<Node> hijos) {
        this.hijos = hijos;
    }
}
