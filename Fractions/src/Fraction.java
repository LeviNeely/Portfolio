//interface Comparable<Fraction>{
//    int compareTo(Fraction f1);
//}

public class Fraction implements Comparable<Fraction> {
    private long numerator;
    private long denominator;
    public Fraction(){
        numerator = 0;
        denominator = 1;
    }
    public Fraction(long n, long d) throws ArithmeticException{
        numerator = n;
        denominator = d;
        if (d == 0){
            throw new ArithmeticException("Denominator cannot be zero");
        }
        else if (d < 0){
            numerator *= -1;
            denominator *= -1;
        }
        reduce();
    }
    private long GCD(){
        long gcd = numerator;
        long remainder = denominator;
        while (remainder != 0){
            long temp = remainder;
            remainder = gcd % remainder;
            gcd = temp;
        }
        return gcd;
    }
    private void reduce(){
        long gcd = GCD();
        numerator /= Math.abs(gcd);
        denominator /= Math.abs(gcd);
    }
    public Fraction plus(Fraction rhs){
        Fraction sum = new Fraction();
        if (this.denominator == rhs.denominator){
            sum.numerator = (this.numerator+rhs.numerator);
            sum.denominator = rhs.denominator;
            sum.reduce();
        }
        else {
            long oldThisDenominator = this.denominator;
            long oldRhsDenominator = rhs.denominator;
            this.numerator *= oldRhsDenominator;
            this.denominator *= oldRhsDenominator;
            rhs.numerator *= oldThisDenominator;
            rhs.denominator *= oldThisDenominator;
            sum.numerator = (this.numerator+rhs.numerator);
            sum.denominator = rhs.denominator;
            sum.reduce();
        }
        return sum;
    }
    public Fraction minus(Fraction rhs){
        Fraction difference = new Fraction();
        if (this.denominator == rhs.denominator) {
            difference.numerator = (this.numerator - rhs.numerator);
            difference.denominator = rhs.denominator;
            difference.reduce();
        }
        else {
            long oldThisDenominator = this.denominator;
            long oldRhsDenominator = rhs.denominator;
            this.numerator *= oldRhsDenominator;
            this.denominator *= oldRhsDenominator;
            rhs.numerator *= oldThisDenominator;
            rhs.denominator *= oldThisDenominator;
            difference.numerator = (this.numerator-rhs.numerator);
            difference.denominator = rhs.denominator;
            difference.reduce();
        }
        return difference;
    }
    public Fraction times(Fraction rhs){
        long n = (this.numerator*rhs.numerator);
        long d = (this.denominator*rhs.denominator);
        Fraction product = new Fraction(n, d);
        product.reduce();
        return product;
    }
    public Fraction dividedBy(Fraction rhs){
        long n = (this.numerator*rhs.denominator);
        long d = (this.denominator*rhs.numerator);
        Fraction quotient = new Fraction(n, d);
        quotient.reduce();
        return quotient;
    }
    public String toString(){
        String fraction = numerator+"/"+denominator;
        return fraction;
    }
    public double toDouble(){
        double n = numerator;
        double d = denominator;
        double decimal = (n/d);
        return decimal;
    }
    public int compareTo(Fraction f1){
        double decimal1 = (double) (this.numerator)/(this.denominator);
        double decimal2 = (double) (f1.numerator)/(f1.denominator);
        int compare;
        if (decimal1 == decimal2){
            compare = 0;
        }
        else if (decimal1 < decimal2){
            compare = -1;
        }
        else {
            compare = 1;
        }
        return compare;
    }
}
