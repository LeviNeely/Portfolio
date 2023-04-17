package assignment05;

import java.util.ArrayList;

public class BinaryNode<T extends Comparable<? super T>> {
    public BinaryNode left, right;
    public T data_;

    /**
     * The constructor for the Binary Node class
     * @param data the data that the node will hold
     */
    public BinaryNode(T data) {
        this.data_ = data;
        left = null;
        right = null;
    }

    /**
     * Inserts a node with the new data onto the appropriate node
     * @param item the data to be inserted into the new node
     * @return true if the insertion happened
     */
    public boolean insert(T item) {
        if (item == null) {
            throw new NullPointerException();
        }
        if (this.data_.compareTo(item) > 0) {
            if (left == null) {
                left = new BinaryNode(item);
                return true;
            }
            else {
                left.insert(item);
            }
        }
        else if (this.data_.compareTo(item) < 0) {
            if (right == null) {
                right = new BinaryNode(item);
                return true;
            }
            else {
                right.insert(item);
            }
        }
        return false;
    }

    /**
     * Finds the size of a BTS using recursion
     * @return the integer of the number of nodes present
     */
    public int getSize() {
        // This if statement covers a situation in which a node has been deleted
        if (this.data_ == null) {
            return 0;
        }
        else if (this.left == null && this.right == null) {
            return 1;
        }
        else if (this.left == null && this.right != null) {
            return 1 + this.right.getSize();
        }
        else if (this.right == null && this.left != null) {
            return 1 + this.left.getSize();
        }
        return 1 + this.left.getSize() + this.right.getSize();
    }

    /**
     * Checks each node to see if it contains the data through recursion
     * @param item the data to be checked for
     * @return true if the value is found to be contained by a node
     */
    public boolean contains(T item) {
        if (this == null || this.data_ == null) {
            return false;
        }
        if (this.data_.compareTo(item) == 0) {
            return true;
        }
        else if (this.data_.compareTo(item) < 0 && this.right != null) {
            return this.right.contains(item);
        }
        else if (this.data_.compareTo(item) > 0 && this.left != null) {
            return this.left.contains(item);
        }
        else {
            return false;
        }
    }

    /**
     * Adds each node to an arraylist in order
     * @param list the list to be added to
     */
    public void toArrayList(ArrayList<T> list) {
        if (this == null) {
            throw new NullPointerException();
        }
        if (this.left != null) {
            this.left.toArrayList(list);
        }
        list.add(this.data_);
        if (this.right != null) {
            this.right.toArrayList(list);
        }
    }

    /**
     * Deletes a node containing the data specified
     * @param item the data that is used to determine if a node must be deleted
     * @return true if the node was found and deleted
     */
    public boolean delete(T item) {
        if (this == null) {
            return false;
        }
        else if (this.data_.compareTo(item) > 0) {
            return this.left.delete(item);
        }
        else if (this.data_.compareTo(item) < 0) {
            return this.right.delete(item);
        }
        else {
            // In this case, all data is moved to appropriate nodes, since the node to be
            // deleted has two children
            if (this.left != null && this.right != null) {
               BinaryNode<T> temp = this;
               BinaryNode<T> minimumNodeForRight = minimumElement(temp.right);
               this.data_ = minimumNodeForRight.data_;
               this.right.delete(minimumNodeForRight.data_);
               return true;
            }
            // Since this node has only a left child, move the data up from there
            else if (this.left != null) {
                BinaryNode<T> temp = this.left;
                this.data_ = temp.data_;
                this.left = temp.left;
                this.right = temp.right;
                return true;
            }
            // Same as above, but with a right child
            else if (this.right != null) {
                BinaryNode<T> temp = this.right;
                this.data_ = temp.data_;
                this.left = temp.left;
                this.right = temp.right;
                return true;
            }
            // The node is a leaf and can be deleted normally
            else {
                this.data_ = null;
                this.left = null;
                this.right = null;
                return true;
            }
        }
    }

    /**
     * Returns the minimumElement of a node
     * @param root the root to be examined
     * @return the Node that is the minimum node
     */
    public BinaryNode<T> minimumElement(BinaryNode<T> root) {
        if (root.left == null) {
            return root;
        }
        else {
            return minimumElement(root.left);
        }
    }
}
