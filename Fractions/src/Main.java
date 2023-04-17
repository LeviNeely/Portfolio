import java.util.ArrayList;
import java.util.Collections;

public class Main {

    public static void main(String[] args) {
        ArrayList<Fraction> list = new ArrayList<Fraction>();
        list.add(new Fraction (1,2));
        list.add(new Fraction (9, 10));
        list.add(new Fraction (1, 50));
        list.add(new Fraction (5, 10));
        for (Fraction f:list){
            System.out.println(f.toString());
        }
        Collections.sort(list);
        for (Fraction f:list){
            System.out.println(f.toString());
        }
    }
}