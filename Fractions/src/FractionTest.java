import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.Collections;

import static org.junit.jupiter.api.Assertions.*;

// Test Class
class FractionTest {
    @Test
    public void runAllTests() {
        Fraction f0 = new Fraction();
        assertEquals("0/1", (f0.toString()));
        Fraction f1 = new Fraction (1,2);
        assertEquals("1/2", f1.toString());
        Fraction f2 = new Fraction (4,-12);
        assertEquals("-1/3", f2.toString());
        Fraction f3 = new Fraction (-10,20);
        try {
            Fraction f4 = new Fraction(10, 0);
        }
        catch (ArithmeticException e){
            System.out.println("Exception caught: Cannot have a denominator of zero");
        }
        assertEquals(1, f1.compareTo(f2));
        assertEquals(0.5, f1.toDouble());
        assertEquals("1/6", (f1.plus(f2)).toString());
        assertEquals(-0.5, f3.toDouble());
        assertEquals("-1/2", f3.toString());
        assertEquals("0/1", (f1.plus(f3)).toString());
        assertEquals("-1/6", (f1.times(f2)).toString());
        assertEquals("1/1", (f1.minus(f3)).toString());
        assertEquals("-3/2", (f1.dividedBy(f2)).toString());
        assertEquals("0/1", (f0.times(f1)).toString());
    }
}