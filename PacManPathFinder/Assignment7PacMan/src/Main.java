import assignment07.Graph;
import assignment07.PathFinder;

import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        String filename = "bigMaze.txt";
        String outputName = "bigMazeOutput.txt";
        PathFinder test = new PathFinder();
        test.solveMaze(filename, outputName);
    }
}