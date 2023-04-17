package assignment07;

import java.util.ArrayList;

public class Node {
    // data_ tells you what type of node it is
    char data_;
    // This boolean tells you whether it has been visited previously in a search
    boolean visited_;
    // This arraylist tells you what neighbors the node has
    ArrayList<Node> neighbors_;
    // This variable allows you to trace where it came from, kind of like a parent
    Node cameFrom;

    /**
     * Generic constructor
     * @param data
     */
    public Node(char data) {
        data_ = data;
        visited_ = false;
        neighbors_ = new ArrayList<Node>();
    }

    /**
     * Simple method to add neighbors to the node
     * @param neighbor the node to be added
     */
    public void addToNeighbors(Node neighbor) {
        neighbors_.add(neighbor);
    }
}
