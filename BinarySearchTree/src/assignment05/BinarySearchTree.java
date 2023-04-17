package assignment05;

import java.util.ArrayList;
import java.util.Collection;
import java.util.NoSuchElementException;

public class BinarySearchTree<T extends Comparable<? super T>> implements SortedSet<T> {
    public BinaryNode root;

    /**
     * Basic constructor for the BinarySearchTree
     */
    public BinarySearchTree() {
        root = null;
    }

    /**
     * Adds the item to the binary search tree
     * @param item
     *          - the item to be added to the binary search tree
     * @return true if the item has been successfully added, false if already contains that element or wasn't added.
     */
    @Override
    public boolean add(T item) {
        if (item == null) {
            throw new NullPointerException();
        }
        else if (this.contains(item)) {
            return false;
        }
        else if (root == null) {
            root = new BinaryNode(item);
            return true;
        }
        return root.insert(item);
    }

    /**
     * Adds all items in a collection to the BST
     * @param items
     *          - the collection of items to be added
     * @return true if all items were added, false if not all items were added
     */
    @Override
    public boolean addAll(Collection<? extends T> items) {
        if (items == null) {
            throw new NullPointerException();
        }
        int oldSize = this.size();
        for (T item : items) {
            if (item == null) {
                throw new NullPointerException();
            }
            this.add(item);
        }
        int newSize = this.size();
        /*
        Comparing the difference between the new and old size to the size of the collection
        allows us to be sure that all the items were added.
         */
        if ((newSize - oldSize) == items.size()) {
            return true;
        }
        return false;
    }

    /**
     * Clears the BST completely, leaving it as though it had just been created.
     */
    @Override
    public void clear() {
        root = null;
    }

    /**
     * Checks to see if the BST contains a node with the data provided
     * @param item
     *          - the data that is to be searched for inside a node inside the BST
     * @return true if it contains a node with this data
     */
    @Override
    public boolean contains(T item) {
        if (item == null) {
            throw new NullPointerException();
        }
        if (root == null) {
            return false;
        }
        return root.contains(item);
    }

    /**
     * Checks to see if the BST contains nodes with the data provided
     * @param items
     *          - the collection of data to be searched for
     * @return true if the BST contains ALL the data searched for
     */
    @Override
    public boolean containsAll(Collection<? extends T> items) {
        int counter = 0;
        for (T item : items) {
            if (item == null) {
                throw new NullPointerException();
            }
            else {
                if (this.contains(item)) {
                    counter++;
                }
            }
        }
        /*
        Using a counter every time that it is sure that the BTS contains the item,
        we can ensure that every item is contained within the BTS.
         */
        if (counter == items.size()) {
            return true;
        }
        return false;
    }

    /**
     * Finds the first ordered (or "least") node in the BST
     * @return the first ordered data of the BST
     * @throws NoSuchElementException
     */
    @Override
    public T first() throws NoSuchElementException {
        BinaryNode<T> currentNode = root;
        while (currentNode.left != null) {
            currentNode = currentNode.left;
        }
        return currentNode.data_;
    }

    /**
     * Finds if the BST is empty
     * @return true if empty
     */
    @Override
    public boolean isEmpty() {
        if (root == null) {
            return true;
        }
        return false;
    }

    /**
     * Finds the last ordered (or "greatest") node in the BST
     * @return the last ordered data of the BST
     * @throws NoSuchElementException
     */
    @Override
    public T last() throws NoSuchElementException {
        BinaryNode<T> currentNode = root;
        while (currentNode.right != null) {
            currentNode = currentNode.right;
        }
        return currentNode.data_;
    }

    /**
     * Removes a node with the specified data
     * @param item
     *          - the item to search for and remove the node that contains it
     * @return true if it is removed successfully
     */
    @Override
    public boolean remove(T item) {
        if (item == null) {
            throw new NullPointerException();
        }
        if (!this.contains(item)) {
            return false;
        }
        return root.delete(item);
    }

    /**
     * Removes all nodes containing the data in the collection
     * @param items
     *          - the collection of data to remove nodes containing it
     * @return true if all the nodes were removed successfully
     */
    @Override
    public boolean removeAll(Collection<? extends T> items) {
        int oldSize = this.size();
        for (T item : items) {
            if (item == null) {
                throw new NullPointerException();
            }
            this.remove(item);
        }
        int newSize = this.size();
        /*
        Since this removes multiple items, the new size should be the old size minus the size of
        the collection. If this is true, then the function can be returned true.
         */
        if (newSize == (oldSize - items.size())) {
            return true;
        }
        return false;
    }

    /**
     * @return the size of the BTS or the number of nodes.
     */
    @Override
    public int size() {
        if (root == null) {
            return 0;
        }
        return root.getSize();
    }

    /**
     * Transfers the data inside the BTS to an arraylist in order.
     * @return the ordered arraylist
     */
    @Override
    public ArrayList<T> toArrayList() {
        ArrayList<T> transfer = new ArrayList<>();
        root.toArrayList(transfer);
        return transfer;
    }
}
