import java.time.LocalDate;

public class DiabeticUser {
    // Name of the user
    public String name_;
    // Date of birth of the user
    public LocalDate dateOfBirth_;
    // The ratio used to calculate how much insulin to take for a certain number of carbs
    public int carbRatio_;
    // The ratio used to calculate how much insulin to take if blood glucose levels are outside the target blood glucose range
    public int correctiveRatio_;
    // The low end of the target blood glucose range
    public int lowTarget_;
    // The high end of the target blood glucose range
    public int highTarget_;
    // Whether the user utilizes an insulin pump
    public boolean usesPump_;
    // The dosecalculator used to calculate dosages
    public DoseCalculator calculator_;

    /**
     * Constructor
     * @param name name of the user
     * @param DOB date of birth of the user
     * @param carbRatio the ratio used to calculate the amount of insulin to take for carbohydrates
     * @param correctiveRatio the ratio used to calculate the amount of insulin to take for out of range blood glucose
     * @param lowTarget the low end of the range of target blood glucose
     * @param highTarget the high end of the range of target blood glucose
     * @param usesPump whether the user utilizes an insulin pump
     */
    public DiabeticUser (String name, LocalDate DOB, int carbRatio, int correctiveRatio, int lowTarget, int highTarget, boolean usesPump) {
        name_ = name;
        // Getting the current date to test the DOB against
        LocalDate today = LocalDate.now();
        // Protecting against invalid date inputs
        if (DOB.isAfter(today) || DOB.isEqual(today) || DOB.getYear() < (today.getYear() - 100)) {
            throw new IllegalArgumentException ("You must use a valid date of birth");
        }
        // Protecting against more invalid inputs
        else if (carbRatio <= 0 || correctiveRatio <= 0 || lowTarget <= 0 || highTarget <= 0) {
            throw new IllegalArgumentException("Value cannot be less than or equal to zero");
        }
        else if (lowTarget > highTarget || lowTarget <= 50 || highTarget >= 300) {
            throw new IllegalArgumentException("Invalid target blood glucose range");
        }
        dateOfBirth_ = DOB;
        carbRatio_ = carbRatio;
        correctiveRatio_ = correctiveRatio;
        lowTarget_ = lowTarget;
        highTarget_ = highTarget;
        usesPump_ = usesPump;
        calculator_ = new DoseCalculator(carbRatio_, correctiveRatio_, lowTarget_, highTarget_);
    }

    /**
     * A method to provide the instructions for how much insulin to use and how to administer it
     * @param carbohydratesInGrams the amount of carbohydrates (in grams) present
     * @param currentBloodGlucose the users current blood glucose level
     * @param fatInGrams the amount (in grams) of fat present
     * @param proteinInGrams the amount (in grams) of protein present
     * @return the string containing the instructions for how much insulin to use and how
     */
    public String dosingInstruction(double carbohydratesInGrams, int currentBloodGlucose, double fatInGrams, double proteinInGrams) {
        String warning = "";
        // If the user's blood sugar is low, but not critically low, then there needs to be a warning so the user can respond accordingly
        if (calculator_.isLow(currentBloodGlucose)) {
            warning = "!!! Blood glucose is low, please take corrective action according to your doctor recommendation before administering insulin dose" +
                    " OR modify insulin dosage accordingly !!! ";
        }
        int carbohydrateDose = calculator_.calculateCarbohydrateDose(carbohydratesInGrams, currentBloodGlucose);
        int fatAndProteinDose = calculator_.calculateFatAndProteinDose(fatInGrams, proteinInGrams);
        // If the user does not utilize a pump, it is recommended to split the overall dose in two
        int combinedSplitDose = (carbohydrateDose + fatAndProteinDose) / 2;
        // The time that the second pump bolus should be administered is a maximum of 8 hours
        String time = "8 hours";
        // Building the dosing instructions for a user without a pump
        String instructions = warning + "Please take " + combinedSplitDose + " unit(s) of insulin as a pre-meal bolus and take " +
                combinedSplitDose + " unit(s) of insulin 1 - 1.5 hours after the meal";
        // Using switch cases to handle time that the pump bolus should be administered over
        switch (fatAndProteinDose) {
            case 1:
                time = "3 hours";
                break;
            case 2:
                time = "4 hours";
                break;
            case 3:
                time = "5 hours";
                break;
        }
        // Building the dosing instructions for a user who utilizes a pump
        if (usesPump_) {
            instructions = warning + "Please take " + carbohydrateDose + " unit(s) of insulin as a pre-meal bolus and take " +
                    fatAndProteinDose + " unit(s) of insulin as an extended bolus over " + time;
            return instructions;
        }
        return instructions;
    }
}
