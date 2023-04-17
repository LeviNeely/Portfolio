package assignment07;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Graph {
    String filename_;
    int xSize_;
    int ySize_;
    // The matrix used to keep track of all the nodes inside the graph
    Node [][] maze_;

    /**
     * Constructor that makes the magic happen
     * @param filename the file to be utilized to create the maze
     */
    public Graph(String filename) {
        // Read in the file
        filename_ = filename;
        Scanner sc;
        try {
            sc = new Scanner(new File(filename_));
        } catch (FileNotFoundException e) {
            throw new RuntimeException(e);
        }
        // Set the graph dimensions to be the first two numbers read in
        String firstLine = sc.nextLine();
        String[] dimensions = firstLine.split(" ");
        ySize_ = Integer.parseInt(dimensions[0]);
        xSize_ = Integer.parseInt(dimensions[1]);
        maze_ = new Node[ySize_][xSize_];
        int row = 0;
        // Read in one char at a time
        while (sc.hasNextLine()) {
            String currentLine = sc.nextLine();
            for (int column = 0; column < xSize_; column++) {
                Node currentNode = new Node(currentLine.charAt(column));
                maze_[row][column] = currentNode;
            }
            row++;
        }
        // After everything is read in, you will need to do the neighbors function for each individual node
        for (int j = 1; j < ySize_ - 1; j++) {
            for (int i = 1; i < xSize_ - 1; i++) {
                // Look up
                if (maze_[j][i - 1].data_ != 'X') {
                    maze_[j][i].addToNeighbors(maze_[j][i - 1]);
                }
                // Look down
                if (maze_[j][i + 1].data_ != 'X') {
                    maze_[j][i].addToNeighbors(maze_[j][i + 1]);
                }
                // Look left
                if (maze_[j - 1][i].data_ != 'X') {
                    maze_[j][i].addToNeighbors(maze_[j - 1][i]);
                }
                // Look right
                if (maze_[j + 1][i].data_ != 'X') {
                    maze_[j][i].addToNeighbors(maze_[j + 1][i]);
                }
            }
        }
    }
}
