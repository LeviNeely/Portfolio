package assignment07;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;

public class PathFinder {
    // start_ finds the starting point for the maze
    static Node start_;
    // end_ finds the ending point for the maze
    static Node end_;

    /**
     * Generic constructor
     */
    public PathFinder() {
    }

    /**
     * A method to solve for the shortest path from the start of a maze to the end of a maze
     * @param inputFileName the name of the file containing the maze to be solved
     * @param outputFileName the name of the output file that should be created
     */
    public static void solveMaze(String inputFileName, String outputFileName) {
        // Initialize the graph from the input file
        Graph maze = new Graph(inputFileName);
        // Find the start and end nodes
        for (Node[] nodes : maze.maze_) {
            for (Node node : nodes) {
                if (node.data_ == 'S') {
                    start_ = node;
                }
                if (node.data_ == 'G') {
                    end_ = node;
                }
            }
        }
        // Use the breadth first search method to find the path and alter the nodes that are a part of the path
        BFS(start_, end_);
        // Write out the new file with the solved maze
        File output = new File(outputFileName);
        FileWriter fw;
        try {
            fw = new FileWriter(output);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        // First write out the dimensions of the maze
        String dimensions = maze.ySize_ + " " + maze.xSize_ + "\n";
        try {
            fw.write(dimensions);
            for (Node[] nodes : maze.maze_) {
                String line = "";
                // Concatenate the individual characters into a single string to write
                for (Node node : nodes) {
                    line += node.data_;
                }
                line += "\n";
                fw.write(line);
            }
            fw.flush();
            fw.close();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * A method to complete the breadth first search
     * @param start the start of the maze
     * @param end the end of the maze
     */
    public static void BFS(Node start, Node end) {
        // An arraylist to keep track of all the nodes that are a part of the path and need to have their data_ changed
        ArrayList<Node> path = new ArrayList<>();
        LinkedList<Node> queue = new LinkedList<>();
        start.visited_ = true;
        queue.add(start);
        while (!queue.isEmpty()) {
            Node n = queue.removeFirst();
            if (n.data_ == end.data_) {
               tracePath(start, n.cameFrom, path);
                // Change each individual node's data to be a '.' to be written for the solved maze
                for (Node node : path) {
                   node.data_ = '.';
                }
            }
            for (Node neighbor : n.neighbors_) {
                if (!neighbor.visited_) {
                    neighbor.visited_ = true;
                    neighbor.cameFrom = n;
                    queue.addLast(neighbor);
                }
            }
        }
    }

    /**
     * A method to trace the shortest path back to the start of the maze
     * @param start the starting point of the maze
     * @param current the current node being analyzed
     * @param path the arraylist the node should be added to so that we can keep track of things
     */
    public static void tracePath(Node start, Node current, ArrayList<Node> path) {
        // If the current node is the start node, you have made it all the way through, so add yourself and end
        if (current.cameFrom == start) {
            path.add(current);
            return;
        }
        // Add the current node and then do it again with the node you came from
        path.add(current);
        tracePath(start, current.cameFrom, path);
    }
}
