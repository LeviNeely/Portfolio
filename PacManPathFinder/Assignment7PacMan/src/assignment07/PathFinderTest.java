package assignment07;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;
import java.util.random.RandomGenerator;

import static org.junit.jupiter.api.Assertions.*;

class PathFinderTest {
    PathFinder pf;
    String fakeFilename;
    String realFilename;
    char invalidInput;
    Node[][] mazeTest;
    ArrayList<Node> pathway;

    @BeforeEach
    void setUp() {
        pf = new PathFinder();
        fakeFilename = "blah.txt";
        realFilename = "tinyMaze.txt";
        invalidInput = 'b';
        mazeTest = new Node[3][3];
        Random random = new Random();
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                mazeTest[i][j] = new Node(' ');
            }
        }
        mazeTest[0][0] = new Node('S');
        mazeTest[2][2] = new Node('G');
        for (int j = 0; j < 3; j++) {
            for (int i = 0; i < 3; i++) {
                // Look up
                if (i > 0) {
                    mazeTest[j][i].addToNeighbors(mazeTest[j][i - 1]);
                }
                // Look down
                if (i < 2) {
                    mazeTest[j][i].addToNeighbors(mazeTest[j][i + 1]);
                }
                // Look left
                if (j > 0) {
                    mazeTest[j][i].addToNeighbors(mazeTest[j - 1][i]);
                }
                // Look right
                if (j < 2) {
                    mazeTest[j][i].addToNeighbors(mazeTest[j + 1][i]);
                }
            }
        }
        pathway = new ArrayList<>();
    }

    @Test
    void solveMaze() throws FileNotFoundException {
        // I tried to throw an illegal argument exception, but it wouldn't let me haha
//        assertThrows(IllegalArgumentException.class, () -> pf.solveMaze(invalidInput, "string"));
        // Testing a fake file name
        assertThrows(RuntimeException.class, () -> pf.solveMaze(fakeFilename, "string.txt"));
        // Using a real file name
        pf.solveMaze(realFilename, "tinyMazeOutput.txt");
        // If the maze solver worked correctly, then the two files should be identical
        File f1 = new File("tinyMazeOutput.txt");
        File f2 = new File("tinyMazeSol.txt");
        Scanner sc1 = new Scanner(f1);
        Scanner sc2 = new Scanner(f2);
        while (sc1.hasNextLine() && sc2.hasNextLine()) {
            String string1 = sc1.nextLine();
            String string2 = sc2.nextLine();
            // Testing the two strings to see if they are identical
            assertTrue(string1.equals(string2));
        }
        // Repeating the test with a different file
        pf.solveMaze("bigMaze.txt", "bigMazeOutput.txt");
        File f3 = new File("bigMazeOutput.txt");
        File f4 = new File("bigMazeSol.txt");
        Scanner sc3 = new Scanner(f3);
        Scanner sc4 = new Scanner(f4);
        while (sc3.hasNextLine() && sc4.hasNextLine()) {
            String string3 = sc3.nextLine();
            String string4 = sc4.nextLine();
            assertTrue(string3.equals(string4));
        }
    }

    @Test
    void BFS() {
        pf.BFS(mazeTest[0][0], mazeTest[2][2]);
        assertTrue(mazeTest[0][0].visited_);
        assertTrue(mazeTest[2][2].visited_);
    }

    @Test
    void tracePath() {
        Node one = new Node('S');
        Node two = new Node(' ');
        Node three = new Node('G');
        one.addToNeighbors(two);
        two.addToNeighbors(one);
        two.addToNeighbors(three);
        three.addToNeighbors(two);
        two.cameFrom = one;
        three.cameFrom = two;
        pf.tracePath(one, three, pathway);
        assertTrue(pathway.size() == 2);
    }
}