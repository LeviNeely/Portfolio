package assignment05;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.NoSuchElementException;

import static org.junit.jupiter.api.Assertions.*;

class BinarySearchTreeTest {
    public BinarySearchTree<Integer> emptyIntBST;
    public BinarySearchTree<Integer> balancedIntBST;
    public BinarySearchTree<Integer> unbalancedIntBST;
    public BinarySearchTree<String> emptyStringBST;
    public BinarySearchTree<String> balancedStringBST;
    public BinarySearchTree<String> unbalancedStringBST;
    public ArrayList<Integer> five;
    public ArrayList<Integer> three;
    public ArrayList<String> threeWords;

    @BeforeEach
    void setUp() {
        emptyIntBST = new BinarySearchTree<>();
        balancedIntBST = new BinarySearchTree<>();
        balancedIntBST.add(3);
        balancedIntBST.add(4);
        balancedIntBST.add(2);
        balancedIntBST.add(1);
        balancedIntBST.add(5);
        unbalancedIntBST = new BinarySearchTree<>();
        for (int i = 1; i < 6; i++) {
            unbalancedIntBST.add(i);
        }
        five = new ArrayList<>();
        for (int i = 1; i < 6; i++) {
            five.add(i);
        }
        three = new ArrayList<>();
        for (int i = 1; i < 4; i++) {
            three.add(i);
        }
        emptyStringBST = new BinarySearchTree<>();
        balancedStringBST = new BinarySearchTree<>();
        balancedStringBST.add("cat");
        balancedStringBST.add("bat");
        balancedStringBST.add("aat");
        balancedStringBST.add("dat");
        balancedStringBST.add("eat");
        unbalancedStringBST = new BinarySearchTree<>();
        unbalancedStringBST.add("aat");
        unbalancedStringBST.add("bat");
        unbalancedStringBST.add("cat");
        unbalancedStringBST.add("dat");
        unbalancedStringBST.add("eat");
        threeWords = new ArrayList<>();
        threeWords.add("cat");
        threeWords.add("bat");
        threeWords.add("aat");
    }

    @Test
    void add() {
        // Testing the add function with integers
        assertTrue(emptyIntBST.add(50));
        assertTrue(emptyIntBST.add(25));
        assertTrue(emptyIntBST.add(75));
        // Testing redundancy adding
        assertFalse(emptyIntBST.add(50));

        // Testing the add function with strings
        assertTrue(emptyStringBST.add("bat"));
        assertTrue(emptyStringBST.add("cat"));
        assertTrue(emptyStringBST.add("aat"));
        // Testing redundancy adding
        assertFalse(emptyStringBST.add("bat"));
    }

    @Test
    void addAll() {
        // Testing on integers
        assertTrue(emptyIntBST.addAll(five));
        // Testing redundancy adding
        assertFalse(balancedIntBST.addAll(five));

        // Testing on strings
        assertTrue(emptyStringBST.addAll(threeWords));
        // Testing redundancy adding
        assertFalse(balancedStringBST.addAll(threeWords));
    }

    @Test
    void clear() {
        // Testing on integers
        balancedIntBST.clear();
        assertTrue(balancedIntBST.isEmpty());

        // Testing on strings
        balancedStringBST.clear();
        assertTrue(balancedStringBST.isEmpty());
    }

    @Test
    void contains() {
        // Testing on integers
        assertTrue(balancedIntBST.contains(5));
        assertFalse(balancedIntBST.contains(0));
        assertFalse(emptyIntBST.contains(3));

        // Testing on strings
        assertTrue(balancedStringBST.contains("eat"));
        assertFalse(balancedStringBST.contains("zat"));
        assertFalse(emptyStringBST.contains("dat"));
    }

    @Test
    void containsAll() {
        // Testing on integers
        assertTrue(balancedIntBST.containsAll(five));
        // Contains on an empty BST
        assertFalse(emptyIntBST.containsAll(five));
        assertTrue(unbalancedIntBST.containsAll(five));
        ArrayList<Integer> test = new ArrayList<>();
        test.add(0);
        test.add(-100);
        // Testing outlandish values
        assertFalse(balancedIntBST.containsAll(test));

        // Testing on strings
        assertTrue(balancedStringBST.containsAll(threeWords));
        // Contains on an empty BST
        assertFalse(emptyStringBST.containsAll(threeWords));
        assertTrue(unbalancedStringBST.containsAll(threeWords));
        ArrayList<String> testString = new ArrayList<>();
        testString.add("zzzz");
        testString.add("ZZZ");
        // Testing outlandish values
        assertFalse(balancedStringBST.containsAll(testString));
    }

    @Test
    void first() {
        // Testing on integers
        assertEquals(1, balancedIntBST.first());
        assertEquals(1, unbalancedIntBST.first());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyIntBST.first());

        // Testing on strings
        assertEquals("aat", balancedStringBST.first());
        assertEquals("aat", unbalancedStringBST.first());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyStringBST.first());
    }

    @Test
    void isEmpty() {
        // Testing on integers
        assertTrue(emptyIntBST.isEmpty());
        assertFalse(balancedIntBST.isEmpty());

        // Testing on strings
        assertTrue(emptyStringBST.isEmpty());
        assertFalse(balancedStringBST.isEmpty());
    }

    @Test
    void last() {
        // Testing on integers
        assertEquals(5, balancedIntBST.last());
        assertEquals(5, unbalancedIntBST.last());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyIntBST.last());

        // Testing on strings
        assertEquals("eat", balancedStringBST.last());
        assertEquals("eat", unbalancedStringBST.last());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyStringBST.last());
    }

    @Test
    void remove() {
        // Testing on integers
        assertTrue(balancedIntBST.contains(4));
        assertEquals(5, balancedIntBST.size());
        assertTrue(balancedIntBST.remove(4));
        assertEquals(4, balancedIntBST.size());
        assertFalse(balancedIntBST.contains(4));
        assertTrue(balancedIntBST.contains(5));
        assertTrue(balancedIntBST.remove(5));
        assertEquals(3, balancedIntBST.size());
        assertFalse(balancedIntBST.contains(5));
        assertFalse(balancedIntBST.remove(5));

        // Testing on strings
        assertTrue(balancedStringBST.contains("dat"));
        assertTrue(balancedStringBST.remove("dat"));
        assertFalse(balancedStringBST.contains("dat"));
        assertTrue(balancedStringBST.contains("eat"));
        assertTrue(balancedStringBST.remove("eat"));
        assertFalse(balancedStringBST.contains("eat"));
        assertFalse(balancedStringBST.remove("eat"));
    }

    @Test
    void removeAll() {
        // Testing by seeing if the BST contains the values afterward
        balancedIntBST.removeAll(three);
        assertFalse(balancedIntBST.containsAll(three));
        assertFalse(emptyIntBST.removeAll(three));
        unbalancedIntBST.removeAll(three);
        assertFalse(unbalancedIntBST.containsAll(three));
        ArrayList<Integer> test = new ArrayList<>();
        test.add(0);
        test.add(-100);
        assertFalse(balancedIntBST.removeAll(test));

        // Testing the more traditional way
        assertTrue(balancedStringBST.removeAll(threeWords));
    }

    @Test
    void size() {
        // Testing on integers
        assertEquals(5, balancedIntBST.size());
        assertEquals(5, unbalancedIntBST.size());
        assertEquals(0, emptyIntBST.size());

        // Testing on strings
        assertEquals(5, balancedStringBST.size());
        assertEquals(5, unbalancedStringBST.size());
        assertEquals(0, emptyStringBST.size());
    }

    @Test
    void toArrayList() {
        // Testing on integers
        assertEquals(five, balancedIntBST.toArrayList());
        assertEquals(five, unbalancedIntBST.toArrayList());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyIntBST.toArrayList());

        // Testing on strings
        ArrayList<String> test = new ArrayList<>();
        test.add("aat");
        test.add("bat");
        test.add("cat");
        test.add("dat");
        test.add("eat");
        assertEquals(test, balancedStringBST.toArrayList());
        assertEquals(test, unbalancedStringBST.toArrayList());
        // Testing on an empty BST
        assertThrows(NullPointerException.class, () -> emptyStringBST.toArrayList());
    }
}