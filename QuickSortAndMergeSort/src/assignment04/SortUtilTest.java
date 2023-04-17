package assignment04;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Random;

import static org.junit.jupiter.api.Assertions.*;

class SortUtilTest {
    Comparator<Integer> nullComparator = null;
    Comparator<Integer> integerComp;
    Comparator<String> stringComp;
    SortUtil allTests;
    int size;
    ArrayList<Integer> nullCase = null;
    ArrayList<Integer> bestCaseInteger;
    ArrayList<Integer> averageCaseInteger;
    ArrayList<Integer> worstCaseInteger;
    ArrayList<Integer> negativeNumbers;
    ArrayList<String> bestCaseString;
    ArrayList<String> worstCaseString;
    ArrayList<String> averageCaseString;

    @BeforeEach
    void setUp() {
        integerComp = Integer::compareTo;
        stringComp = String::compareTo;
        allTests = new SortUtil();
        size = 10000;
        bestCaseInteger = allTests.generateBestCaseInteger(size);
        averageCaseInteger = allTests.generateAverageCaseInteger(size);
        worstCaseInteger = allTests.generateWorstCaseInteger(size);
        negativeNumbers = allTests.generateAverageCaseInteger(size);
        // A basic for loop to randomly convert some of the randomly generated numbers
        // into negative ones
        for (int i = 0; i < size - 1; i++) {
            int random = new Random().nextInt(0, 1);
            if (random == 0) {
                negativeNumbers.set(i, (negativeNumbers.get(i)*-1));
            }
        }
        bestCaseString = allTests.generateBestCaseString();
        worstCaseString = allTests.generateWorstCaseString();
        averageCaseString = allTests.generateAverageCaseString(size, 5);
    }

    @Test
    void mergesort() {

        // Testing null cases
        assertThrows(RuntimeException.class, () -> allTests.mergesort(nullCase, integerComp));
        assertThrows(RuntimeException.class, () -> allTests.mergesort(bestCaseInteger, nullComparator));

        // Testing integers
        allTests.mergesort(bestCaseInteger, integerComp);
        allTests.mergesort(averageCaseInteger, integerComp);
        allTests.mergesort(worstCaseInteger, integerComp);
        allTests.mergesort(negativeNumbers, integerComp);
        // If the sort worked as expected, then each value should be smaler or equal to the next
        for (int i = 0; i < size-2; i++) {
            assertTrue(bestCaseInteger.get(i) <= bestCaseInteger.get(i+1));
            assertTrue(averageCaseInteger.get(i) <= averageCaseInteger.get(i+1));
            assertTrue(worstCaseInteger.get(i) <= worstCaseInteger.get(i+1));
            assertTrue(negativeNumbers.get(i) <= negativeNumbers.get(i+1));
        }

        // Testing strings
        allTests.mergesort(bestCaseString, stringComp);
        allTests.mergesort(worstCaseString, stringComp);
        allTests.mergesort(averageCaseString, stringComp);
        // First two tests are just testing the alphabet in best and worst cases, so size is only 26
        for (int i = 0; i < 24; i++) {
            assertTrue(stringComp.compare(bestCaseString.get(i), bestCaseString.get(i+1)) <= 0);
            assertTrue(stringComp.compare(worstCaseString.get(i), worstCaseString.get(i+1)) <= 0);
        }
        // Last case is sorting alphanumeric strings of length(5) for the full size of the other ArrayLists
        for (int i = 0; i < size-2; i++) {
            assertTrue(stringComp.compare(averageCaseString.get(i), averageCaseString.get(i+1)) <= 0);
        }
    }

    @Test
    void quicksort() {

        // Testing null cases
        assertThrows(RuntimeException.class, () -> allTests.quicksort(nullCase, integerComp));
        assertThrows(RuntimeException.class, () -> allTests.quicksort(bestCaseInteger, nullComparator));

        // Testing integers
        allTests.quicksort(bestCaseInteger, integerComp);
        allTests.quicksort(averageCaseInteger, integerComp);
        allTests.quicksort(worstCaseInteger, integerComp);
        allTests.quicksort(negativeNumbers, integerComp);
        // If the sort worked as expected, then each value should be smaler or equal to the next
        for (int i = 0; i < size-2; i++) {
            assertTrue(bestCaseInteger.get(i) <= bestCaseInteger.get(i+1));
            assertTrue(averageCaseInteger.get(i) <= averageCaseInteger.get(i+1));
            assertTrue(worstCaseInteger.get(i) <= worstCaseInteger.get(i+1));
            assertTrue(negativeNumbers.get(i) <= negativeNumbers.get(i+1));
        }

        // Testing strings
        allTests.quicksort(bestCaseString, stringComp);
        allTests.quicksort(worstCaseString, stringComp);
        allTests.quicksort(averageCaseString, stringComp);
        // First two tests are just testing the alphabet in best and worst cases, so size is only 26
        for (int i = 0; i < 24; i++) {
            assertTrue(stringComp.compare(bestCaseString.get(i), bestCaseString.get(i+1)) <= 0);
            assertTrue(stringComp.compare(worstCaseString.get(i), worstCaseString.get(i+1)) <= 0);
        }
        // Last case is sorting alphanumeric strings of length(5) for the full size of the other ArrayLists
        for (int i = 0; i < size-2; i++) {
            assertTrue(stringComp.compare(averageCaseString.get(i), averageCaseString.get(i+1)) <= 0);
        }
    }

    @Test
    void swap() {

        // Testing integers
        assertEquals(3, bestCaseInteger.get(3));
        assertEquals(4, bestCaseInteger.get(4));
        allTests.swap(bestCaseInteger, 3, 4);
        assertEquals(3, bestCaseInteger.get(4));
        assertEquals(4, bestCaseInteger.get(3));

        // Testing strings
        assertEquals("a", bestCaseString.get(0));
        assertEquals("b", bestCaseString.get(1));
        allTests.swap(bestCaseString, 0, 1);
        assertEquals("a", bestCaseString.get(1));
        assertEquals("b", bestCaseString.get(0));
    }

    @Test
    void pivotSelection() {
        assertEquals(0, bestCaseInteger.get(allTests.pivotSelection(bestCaseInteger, 0, 1, -1)));
        assertTrue(allTests.pivotSelection(bestCaseInteger, 10, 20, 0) >= 10 || allTests.pivotSelection(bestCaseInteger, 10, 20, 0) <= 10);
        assertEquals(5, bestCaseInteger.get(allTests.pivotSelection(bestCaseInteger, 4, 5, 1)));
        assertEquals(7, bestCaseInteger.get(allTests.pivotSelection(bestCaseInteger, 6, 8, 2)));
    }
}