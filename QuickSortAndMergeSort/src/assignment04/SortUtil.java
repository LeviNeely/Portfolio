package assignment04;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Random;

public class SortUtil {
    public static int insertionThreshold = 15;
    public static int pivotGenerator;

    /**
     * mergesort is a driver method that runs the overall mergesort functionality
     * @param list the arraylist to be sorted of type T
     * @param comp the comparator to be utilized for type T
     * @param <T> the type used in the arraylist
     */
    public static <T> void mergesort(ArrayList<T> list, Comparator<? super T> comp) {
        if (list == null) {
            throw new RuntimeException("Empty list not allowed");
        }
        if (comp == null) {
            throw new RuntimeException("Comparator required");
        }
        ArrayList<T> temp = new ArrayList<>(list);
        recursiveMerge(list, temp, comp, 0, list.size());
    }

    /**
     * recursiveMerge is where the recursion of the mergesort happens. The method repeats until the if statements
     * return true, allowing for the insertionSort to finish the job
     * @param list the arraylist to be recursively merged of type T
     * @param temp the temporary arraylist to be copied into
     * @param comp the comparator for type T
     * @param start the lowest index of the arraylist or the section being worked on
     * @param end the highest index of the arraylist or the section being worked on
     * @param <T> the type of the arraylist
     */
    public static <T> void recursiveMerge(ArrayList<T> list, ArrayList<T> temp, Comparator<? super T> comp, int start, int end) {
        //if the difference between start and end equals the threshold, insertion sort before merge
        if (end - start <= insertionThreshold) {
            insertionSort(list, temp, comp, start, end);
            return;
        }
        //calculate the middle index
        int mid = (start + end) / 2;
        //call the method for the lower indices
        recursiveMerge(list, temp, comp, start, mid);
        //call the method for the higher indices
        recursiveMerge(list, temp, comp, mid, end);
        //send the information to the merge sort method
        merge(list, temp, comp, start, mid, end);
    }

    /**
     * The merge function merges two arraylists that have been sorted back into a complete arraylist
     * @param list the list that is being sorted
     * @param temp the temporary array that has the correctly ordered values stored in it
     * @param comp the comparator for type T
     * @param start the low index of the section being sorted
     * @param mid the mid point index of the section being sorted
     * @param end the high index of the section being sorted
     * @param <T> the type of the arraylist
     */
    public static <T> void merge(ArrayList<T> list, ArrayList<T> temp, Comparator<? super T> comp, int start, int mid, int end) {
        int i = start, j = mid;
        //merge the arrays by index value
        for (int k = start; k < end; k++) {
            //if the higher indices are empty or larger than the smaller indices
            if (i < mid && (j >= end || comp.compare(list.get(j), list.get(i)) > 0)) {
                temp.set(k, list.get(i));
                i++;
            }
            //otherwise
            else {
                temp.set(k, list.get(j));
                j++;
            }
        }
        //copy the temp subarray to list
        for (int k = start; k < end; k++) {
            list.set(k, temp.get(k));
        }
    }

    /**
     * quicksort is a driver method for the quicksort functionality
     * @param list the list to be quicksorted of type T
     * @param comp the comparator for type T
     * @param <T> the type in the arraylist
     */
    public static <T> void quicksort(ArrayList<T> list, Comparator<? super T> comp) {
        if (list == null) {
            throw new RuntimeException("Empty list not allowed");
        }
        if (comp == null) {
            throw new RuntimeException("Comparator required");
        }
        // The pivot generator is randomly generated, however it is possible to hardcode this value
        // in order to test different pivot selections (see pivotSelection method)
        pivotGenerator = new Random().nextInt(-1, 2);
        recursiveQuicksort(list, 0, list.size()-1, pivotGenerator, comp);
    }

    /**
     * recursiveQuicksort is where the recursion for the quicksort happens. The method repeats itself
     * until it determines that the arraylist section that is being used is small enough to stop being sorted.
     * @param list the arraylist of type T to be quicksorted
     * @param low the lowest index of the section being quicksorted
     * @param high the highest index of the section being quicksorted
     * @param pivotGenerator the value that determines pivotSelection
     * @param comp the comparator for type T
     * @param <T> the type of data in arraylist
     */
    public static <T> void recursiveQuicksort(ArrayList<T> list, int low, int high, int pivotGenerator, Comparator<? super T> comp) {
        // Only returns false when the size of the section has become too small and is properly sorted
        if (low < high) {
            int partitionIndex = partition(list, low, high, pivotGenerator, comp);
            recursiveQuicksort(list, low, partitionIndex - 1, pivotGenerator, comp);
            recursiveQuicksort(list, partitionIndex + 1, high, pivotGenerator, comp);
        }
    }

    /**
     * partition identifies where the partition should happen (aka, where the division of the arraylist
     * should occur) to further go through recursion and sort in those smaller parts
     * @param list the arraylist of type T to be sorted
     * @param low the lowest index of the section being sorted
     * @param high the highest index of the section being sorted
     * @param pivotGenerator the value used to select the pivot
     * @param comp the comparator for type T
     * @param <T> the type of the arraylist
     * @return int which is the index to be used to partition
     */
    public static <T> int partition(ArrayList<T> list, int low, int high, int pivotGenerator, Comparator<? super T> comp) {
        T pivot = list.get(pivotSelection(list, low, high, pivotGenerator));
        // i keeps track of which values need to be swapped in order to place values larger
        // than the pivot into their proper place.
        int i = (low - 1);
        for (int j = low; j < high; j++) {
            int genericComparison = comp.compare(list.get(j), pivot);
            if (genericComparison <= 0) {
                i++;
                // if the value is less than the pivot, then swap it
                swap(list, i, j);
            }
        }
        // after the loop has ran, it is important to replace the high value that was
        // swapped out in the pivotSelection method
        swap(list, i + 1, high);
        return (i + 1);
    }

    /**
     * swap simply swaps two values
     * @param list the arraylist of type T that is being sorted
     * @param i index 1
     * @param j index 2
     * @param <T> type that arraylist is composed of
     */
    public static <T> void swap(ArrayList<T> list, int i, int j) {
        T temp = list.get(i);
        list.set(i, list.get(j));
        list.set(j, temp);
    }

    /**
     * pivotSelection ensures that the appropriate pivot is selected in all the other methods.
     * @param list the arraylist of type T to be sorted
     * @param low the lowest index of the section being sorted
     * @param high the highest index of the section being sorted
     * @param pivotGenerator determined in the quicksort driver function, determines which index to use
     *                       for the pivot.
     * @param <T> the type that arraylist is composed of.
     * @return int the index of the value to be used as the pivot (it will always be the high value, but must
     * first be swapped)
     */
    public static <T> int pivotSelection(ArrayList<T> list, int low, int high, int pivotGenerator) {
        if (pivotGenerator == -1) {
            // this case chooses the lowest index
            swap(list, low, high);
            return high;
        }
        else if (pivotGenerator == 1) {
            // this case chooses the highest index
            return high;
        }
        else if (pivotGenerator == 2) {
            // this case chooses the median index
            int median = (low + high)/2;
            swap(list, median, high);
            return high;
        }
        else {
            // this case chooses a random index to utilize
            swap(list, (new Random().nextInt(low, high)), high);
            return high;
        }
    }

    /**
     * generateBestCaseInteger simply fills the arraylist with integers in ascending order
     * @param size the desired size of the arraylist
     * @return ArrayList<Integer> to be used for sorting
     */
    public static ArrayList<Integer> generateBestCaseInteger(int size) {
        ArrayList<Integer> list = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            list.add(i);
        }
        return list;
    }

    /**
     * generateBestCaseString simply fills an arraylist with the alphabet in ascending order
     * @return ArrayList<String> to be sorted.
     */
    public static ArrayList<String> generateBestCaseString() {
        ArrayList<String> list = new ArrayList<>();
        String alphabet = "abcdefghijklmnopqrstuvwxyz";
        for (int i = 0; i < 26; i++){
            list.add(String.valueOf(alphabet.charAt(i)));
        }
        return list;
    }

    /**
     * generateAverageCaseInteger generates random integers to be filled into an arraylist
     * @param size the desired size of the arraylist
     * @return ArrayList<Integer> to be sorted
     */
    public static ArrayList<Integer> generateAverageCaseInteger(int size) {
        ArrayList<Integer> list = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            list.add(new Random().nextInt(size));
        }
        return list;
    }

    /**
     * generateAverageCaseString generates an arraylist with randomly generated alphanumeric strings
     * of a chosen size.
     * @param listSize desired size of the arraylist
     * @param stringSize desired size of the randomly generated alphanumeric strings
     * @return ArrayList<String> to be sorted
     */
    public static ArrayList<String> generateAverageCaseString(int listSize, int stringSize) {
        ArrayList<String> list = new ArrayList<>();
        String alphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "1234567890" + "abcdefghijklmnopqrstuvwxyz";
        // loop to fill the arraylist
        for (int i = 0; i < listSize; i++) {
            StringBuilder sb = new StringBuilder(stringSize);
            // loop to build the individual strings
            for (int j = 0; j < stringSize; j++) {
                int random = (int)(alphaNumericString.length()*Math.random());
                sb.append(alphaNumericString.charAt(random));
            }
            list.add(sb.toString());
        }
        return list;
    }

    /**
     * generateWorstCaseInteger fills an arraylist in descending order
     * @param size the desired size of the arraylist
     * @return ArrayList<Integer> to be sorted
     */
    public static ArrayList<Integer> generateWorstCaseInteger(int size) {
        ArrayList<Integer> list = new ArrayList<>(size);
        for (int i = size - 1; i >= 0; i--) {
            list.add(i);
        }
        return list;
    }

    /**
     * generateWorstCaseString fills an arraylist with the alphabet in descending order
     * @return ArrayList<String> to be sorted
     */
    public static ArrayList<String> generateWorstCaseString() {
        ArrayList<String> list = new ArrayList<>();
        String alphabet = "abcdefghijklmnopqrstuvwxyz";
        for (int i = 25; i >= 0; i--){
            list.add(String.valueOf(alphabet.charAt(i)));
        }
        return list;
    }

    /**
     * insertionSort sorts the values inside a specific section determined by the member variable
     * insertionThreshold
     * @param list the arraylist of type T to be sorted
     * @param temp the temporary arraylist to copy values into
     * @param comp the comparator for type T
     * @param start the lowest index of the section being sorted
     * @param end the highest index of the section being sorted
     * @param <T> the type that arraylist is comprised of
     */
    public static <T> void insertionSort(ArrayList<T> list, ArrayList<T> temp, Comparator<? super T> comp, int start, int end) {
        for (int i = start; i < end; i++) {
            for (int j = end - 1; j > start; j--) {
                if (comp.compare(list.get(j), list.get(j - 1)) < 0) {
                    T tempValue = list.get(j - 1);
                    list.set(j - 1, list.get(j));
                    list.set(j, tempValue);
                }
            }
        }
        //copy the temp from the list
        for (int k = start; k < end; k++) {
            temp.set(k, list.get(k));
        }
    }
}
