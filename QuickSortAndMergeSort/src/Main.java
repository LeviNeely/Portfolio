import assignment04.SortUtil;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        SortUtil timingTest = new SortUtil();
        Comparator<Integer> integerComp = Integer::compareTo;
        for (double i = 10; i < 21; i++) {
            int size = (int) Math.pow(2, i);
            long startTime, midpointTime;
            long totalStartToMid = 0;
            ArrayList<Integer> testList = timingTest.generateWorstCaseInteger(size);
            int timesToTest = 1000;
            for (int k = 0; k < timesToTest; k++) {
                startTime = System.nanoTime();
                while (System.nanoTime() - startTime < 1000) {

                }
                startTime = System.nanoTime();
                timingTest.quicksort(testList, integerComp);
                midpointTime = System.nanoTime();
                totalStartToMid += (midpointTime - startTime);
            }
            double averageStartToMid = (double)(totalStartToMid/timesToTest)/1000000;
            System.out.println("It took " + averageStartToMid + " milliseconds to complete quicksort for an array size of 2^" + i);
            testList = timingTest.generateWorstCaseInteger(size);
            for (int l = 0; l < timesToTest; l++) {
                startTime = System.nanoTime();
                while (System.nanoTime() - startTime < 1000) {

                }
                startTime = System.nanoTime();
                timingTest.mergesort(testList, integerComp);
                midpointTime = System.nanoTime();
                totalStartToMid += (midpointTime - startTime);
            }
            averageStartToMid = (double)(totalStartToMid/timesToTest)/1000000;
            System.out.println("It took " + averageStartToMid + " milliseconds to complete mergesort for an array size of 2^" + i);
        }
    }
}