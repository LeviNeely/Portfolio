public class DoseCalculator {
    // The carb ratio used to calculate how many units of insulin to use
    public int carbRatio_;
    // The ratio used to correct blood glucose if out of target blood glucose range
    public int correctiveRatio_;
    // The low end of the range for target blood glucose
    public int lowTarget_;
    // The high end of the range for target blood glucose
    public int highTarget_;

    /**
     * Constructor
     * @param carbRatio the ratio used to calculate how many insulin units to administer for a certain number of carbohydrates
     * @param correctiveRatio the ratio used to correct a high blood sugar
     * @param lowTarget the low end of the target blood glucose range
     * @param highTarget the high end of the target blood glucose range
     */
    public DoseCalculator(int carbRatio, int correctiveRatio, int lowTarget, int highTarget) {
        // Protecting against invalid inputs
        if (carbRatio <= 0 || correctiveRatio <= 0 || lowTarget <= 0 || highTarget <= 0) {
            throw new IllegalArgumentException("Value cannot be less than or equal to zero");
        }
        else if (lowTarget > highTarget || lowTarget <= 50 || highTarget >= 300) {
            throw new IllegalArgumentException("Invalid target blood glucose range");
        }
        carbRatio_ = carbRatio;
        correctiveRatio_ = correctiveRatio;
        lowTarget_ = lowTarget;
        highTarget_ = highTarget;
    }

    /**
     * A method used to calculate the number of insulin units to administer for the carbohydrates present
     * @param carbohydratesInGrams the amount of carbohydrates (in grams) present
     * @param currentBloodGlucose the current blood glucose level of the user
     * @return the amount of insulin to be administered for the carbohydrates + any correction
     */
    public int calculateCarbohydrateDose(double carbohydratesInGrams, int currentBloodGlucose) {
        // Testing for invalid inputs
        if (carbohydratesInGrams < 0 || currentBloodGlucose <= 0) {
            throw new IllegalArgumentException("Value must be greater than or equal to zero");
        }
        else if (currentBloodGlucose < 40 || currentBloodGlucose > 400) {
            throw new IllegalArgumentException("Seek medical attention or retest blood glucose levels");
        }
        int correction = 0;
        // Correction is only used if above the high point of the target blood glucose range
        if (currentBloodGlucose > highTarget_) {
            correction = (currentBloodGlucose - highTarget_) / correctiveRatio_;
        }
        int insulinDose = (int) Math.round(carbohydratesInGrams / carbRatio_);
        return insulinDose + correction;
    }

    /**
     * A method used to calculate the number of insulin units to administer for the fat and protein present
     * @param fatInGrams the amount of fat (in grams) present
     * @param proteinInGrams the amount of protein (in grams) present
     * @return the amount of insulin to be administered for the protein and fat present
     */
    public int calculateFatAndProteinDose(double fatInGrams, double proteinInGrams) {
        // Protecting against invalid inputs
        if (fatInGrams < 0 || proteinInGrams < 0) {
            throw new IllegalArgumentException("Amount must be greater than or equal to zero");
        }
        // Calculating the carbohydrate equivalents (fats and proteins eventually get converted into carbohydrate
        // equivalents in the body)
        double carbohydrateEquivalents = ((fatInGrams * 9) + (proteinInGrams * 4)) / 10;
        int insulinDose = (int) Math.round(carbohydrateEquivalents / carbRatio_);
        return insulinDose;
    }

    /**
     * A method used to determine if the current blood glucose level of the user is low
     * @param currentBloodGlucose the user's current blood glucose level
     * @return true if the user's blood glucose levels are lower than the low point of the target blood glucose range
     */
    public boolean isLow(int currentBloodGlucose) {
        // Protecting against invalid inputs
        if (currentBloodGlucose <= 0) {
            throw new IllegalArgumentException("Value must be greater than or equal to zero");
        }
        // If blood glucose levels are within these levels, the user needs to seek medical attention immediately or
        // there is an error with their blood glucose monitoring device
        else if (currentBloodGlucose < 40 || currentBloodGlucose > 400) {
            throw new IllegalArgumentException("Seek medical attention or retest blood glucose levels");
        }
        if (currentBloodGlucose < lowTarget_) {
            return true;
        }
        return false;
    }
}
