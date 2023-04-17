import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class DoseCalculatorTest {
    int normalCarbRatio;
    int negativeCarbRatio;
    int zeroCarbRatio;
    int normalCorrectiveRatio;
    int negativeCorrectiveRatio;
    int zeroCorrectiveRatio;
    int normalLowTarget;
    int abnormalLowTarget;
    int negativeLowTarget;
    int zeroLowTarget;
    int normalHighTarget;
    int abnormalHighTarget;
    int negativeHighTarget;
    int zeroHighTarget;
    DoseCalculator doseCalculator;
    double normalCarbs;
    double negativeCarbs;
    double wildCarbs;
    double zeroCarbs;
    int normalCBG;
    int negativeCBG;
    int lowCBG;
    int highCBG;
    int zeroCBG;
    int extremeLowCBG;
    int extremeHighCBG;
    double normalFat;
    double negativeFat;
    double wildFat;
    double zeroFat;
    double normalProtein;
    double wildProtein;
    double negativeProtein;
    double zeroProtein;

    @BeforeEach
    void setUp() {
        normalCarbRatio = 10;
        negativeCarbRatio = -5;
        zeroCarbRatio = 0;
        normalCorrectiveRatio = 20;
        negativeCorrectiveRatio = -1;
        zeroCorrectiveRatio = 0;
        normalLowTarget = 70;
        abnormalLowTarget = 25;
        negativeLowTarget = -60;
        zeroLowTarget = 0;
        normalHighTarget = 150;
        abnormalHighTarget = 350;
        negativeHighTarget = -45;
        zeroHighTarget = 0;
        doseCalculator = new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, normalLowTarget, normalHighTarget);
        normalCarbs = 25;
        negativeCarbs = -45.63;
        wildCarbs = 56.938;
        zeroCarbs = 0;
        normalCBG = 125;
        negativeCBG = -125;
        lowCBG = 55;
        highCBG = 350;
        zeroCBG = 0;
        extremeHighCBG = 580;
        extremeLowCBG = 5;
        normalFat = 5;
        negativeFat = -5;
        wildFat = 32.682;
        zeroFat = 0;
        normalProtein = 5;
        wildProtein = 45.2694;
        negativeProtein = -5;
        zeroProtein = 0;
    }

    @Test
    void DoseCalculator() {
        // Testing all the potential values that could break the constructor (negative, zero, and edge cases for each parameter)
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(negativeCarbRatio, normalCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, negativeCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(zeroCarbRatio, normalCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, zeroCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, abnormalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, normalLowTarget, abnormalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, negativeLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, normalLowTarget, negativeHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, zeroLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, normalLowTarget, zeroHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(negativeCarbRatio, negativeCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(zeroCarbRatio, zeroCorrectiveRatio, normalLowTarget, normalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, abnormalLowTarget, abnormalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, negativeLowTarget, negativeHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, zeroLowTarget, zeroHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(negativeCarbRatio, negativeCorrectiveRatio, negativeLowTarget, negativeHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(zeroCarbRatio, zeroCorrectiveRatio, zeroLowTarget, zeroHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(negativeCarbRatio, negativeCorrectiveRatio, abnormalLowTarget, abnormalHighTarget));
        assertThrows(IllegalArgumentException.class, () -> new DoseCalculator(zeroCarbRatio, zeroCorrectiveRatio, abnormalLowTarget, abnormalHighTarget));
    }

    @Test
    void calculateCarbohydrateDose() {
        // Testing a variety of possible cases for dose calculation
        assertEquals(3, doseCalculator.calculateCarbohydrateDose(normalCarbs, normalCBG));
        assertEquals(6, doseCalculator.calculateCarbohydrateDose(wildCarbs, normalCBG));
        assertEquals(3, doseCalculator.calculateCarbohydrateDose(normalCarbs, lowCBG));
        assertEquals(6, doseCalculator.calculateCarbohydrateDose(wildCarbs, lowCBG));
        assertEquals(13, doseCalculator.calculateCarbohydrateDose(normalCarbs, highCBG));
        assertEquals(16, doseCalculator.calculateCarbohydrateDose(wildCarbs, highCBG));
        assertEquals(0, doseCalculator.calculateCarbohydrateDose(zeroCarbs, normalCBG));
        assertEquals(0, doseCalculator.calculateCarbohydrateDose(zeroCarbs, lowCBG));
        assertEquals(10, doseCalculator.calculateCarbohydrateDose(zeroCarbs, highCBG));
        // Testing every possible case that could break the dose calculation (negative, zero, and edge cases for each parameter)
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateCarbohydrateDose(negativeCarbs, normalCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateCarbohydrateDose(normalCarbs, negativeCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateCarbohydrateDose(normalCarbs, zeroCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateCarbohydrateDose(normalCarbs, extremeHighCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateCarbohydrateDose(normalCarbs, extremeLowCBG));
    }

    @Test
    void calculateFatAndProteinDose() {
        // Testing a variety of possible inputs
        assertEquals(0, doseCalculator.calculateFatAndProteinDose(zeroFat, zeroProtein));
        assertEquals(0, doseCalculator.calculateFatAndProteinDose(zeroFat, normalProtein));
        assertEquals(0, doseCalculator.calculateFatAndProteinDose(normalFat, zeroProtein));
        assertEquals(1, doseCalculator.calculateFatAndProteinDose(normalFat, normalProtein));
        assertEquals(5, doseCalculator.calculateFatAndProteinDose(wildFat, wildProtein));
        // Testing negative cases
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateFatAndProteinDose(negativeFat, negativeProtein));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateFatAndProteinDose(negativeFat, zeroProtein));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.calculateFatAndProteinDose(zeroFat, negativeProtein));
    }

    @Test
    void isLow() {
        // Testing low, normal, and high blood glucose levels
        assertTrue(doseCalculator.isLow(lowCBG));
        assertFalse(doseCalculator.isLow(normalCBG));
        assertFalse(doseCalculator.isLow(highCBG));
        // Testing negative, zero, and edge cases
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.isLow(negativeCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.isLow(zeroCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.isLow(extremeLowCBG));
        assertThrows(IllegalArgumentException.class, () -> doseCalculator.isLow(extremeHighCBG));
    }
}