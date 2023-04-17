import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.time.LocalDate;
import static org.junit.jupiter.api.Assertions.*;

class DiabeticUserTest {
    String name1;
    String name2;
    String weirdName;
    LocalDate normalDate;
    LocalDate negativeYear;
    // These cases were actually not accepted with the LocalDate class, so this became redundant
//    LocalDate negativeMonth;
//    LocalDate negativeDay;
//    LocalDate impossibleJan;
//    LocalDate impossibleFeb;
//    LocalDate impossibleLeapYear;
//    LocalDate impossibleApril;
    LocalDate impossibleFutureDate;
    LocalDate impossiblePastDate;
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
    boolean usesPump;
    boolean doesNotUsePump;
    DoseCalculator calculator;
    DiabeticUser normalPumpUser;
    DiabeticUser normalUser;

    @BeforeEach
    void setUp() {
        name1 = "John";
        name2 = "Jane";
        weirdName = "24601!*";
        normalDate = LocalDate.of(1994, 1, 13);
        negativeYear = LocalDate.of(-500, 1, 13);
        // These cases were actually not accepted with the LocalDate class, so this became redundant
//        negativeMonth = LocalDate.of(1994, -5, 13);
//        negativeDay = LocalDate.of(1994, 1, -13);
//        impossibleJan = LocalDate.of(1994, 1, 32);
//        impossibleFeb = LocalDate.of(1994, 2, 29);
//        impossibleLeapYear = LocalDate.of(1992, 2, 30);
//        impossibleApril = LocalDate.of(1994, 4, 31);
        impossibleFutureDate = LocalDate.of(2023, 3, 15);
        impossiblePastDate = LocalDate.of(896, 3, 23);
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
        usesPump = true;
        doesNotUsePump = false;
        calculator = new DoseCalculator(normalCarbRatio, normalCorrectiveRatio, normalLowTarget, normalHighTarget);
        normalPumpUser = new DiabeticUser(name1, normalDate, normalCarbRatio, normalCorrectiveRatio, normalLowTarget,
                normalHighTarget, usesPump);
        normalUser = new DiabeticUser(name1, normalDate, normalCarbRatio, normalCorrectiveRatio, normalLowTarget,
                normalHighTarget, doesNotUsePump);
    }

    @Test
    void DiabeticUser() {
        // Testing dates that would not be accepted
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, negativeYear, normalCarbRatio,
                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        // These cases were actually not accepted with the LocalDate class, so this became redundant
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, negativeMonth, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, negativeDay, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, impossibleJan, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, impossibleFeb, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, impossibleLeapYear, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
//        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, impossibleFutureDate, normalCarbRatio,
//                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, impossiblePastDate, normalCarbRatio,
                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        // Testing negative, zero, and edge cases
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name2, normalDate, negativeCarbRatio,
                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(weirdName, normalDate, zeroCarbRatio,
                normalCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                negativeCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                zeroCorrectiveRatio, normalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, abnormalLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, negativeLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, zeroLowTarget, normalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, normalLowTarget, abnormalHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, normalLowTarget, negativeHighTarget, usesPump));
        assertThrows(IllegalArgumentException.class, () -> new DiabeticUser(name1, normalDate, normalCarbRatio,
                normalCorrectiveRatio, normalLowTarget, zeroHighTarget, usesPump));
    }

    @Test
    void dosingInstruction() {
        // Constructing the expected messages
        String normalPumpMessage = "Please take 3 unit(s) of insulin as a pre-meal bolus and take 1 unit(s) of insulin " +
                "as an extended bolus over 3 hours";
        String normalMessage = "Please take 2 unit(s) of insulin as a pre-meal bolus and take 2 unit(s) of insulin 1 - " +
                "1.5 hours after the meal";
        String lowPumpMessage = "!!! Blood glucose is low, please take corrective action according to your doctor " +
                "recommendation before administering insulin dose OR modify insulin dosage accordingly !!! Please take 3 " +
                "unit(s) of insulin as a pre-meal bolus and take 1 unit(s) of insulin as an extended bolus over 3 hours";
        String lowMessage = "!!! Blood glucose is low, please take corrective action according to your doctor " +
                "recommendation before administering insulin dose OR modify insulin dosage accordingly !!! Please take 2 " +
                "unit(s) of insulin as a pre-meal bolus and take 2 unit(s) of insulin 1 - 1.5 hours after the meal";
        String highPumpMessage = "Please take 13 unit(s) of insulin as a pre-meal bolus and take 1 unit(s) of insulin " +
                "as an extended bolus over 3 hours";
        String highMessage = "Please take 7 unit(s) of insulin as a pre-meal bolus and take 7 unit(s) of insulin 1 - " +
                "1.5 hours after the meal";
        // Testing expected messages with various different scenarios
        assertEquals(normalPumpMessage, normalPumpUser.dosingInstruction(normalCarbs, normalCBG, normalFat, normalProtein));
        assertEquals(normalMessage, normalUser.dosingInstruction(normalCarbs, normalCBG, normalFat, normalProtein));
        assertEquals(lowPumpMessage, normalPumpUser.dosingInstruction(normalCarbs, lowCBG, normalFat, normalProtein));
        assertEquals(lowMessage, normalUser.dosingInstruction(normalCarbs, lowCBG, normalFat, normalProtein));
        assertEquals(highPumpMessage, normalPumpUser.dosingInstruction(normalCarbs, highCBG, normalFat, normalProtein));
        assertEquals(highMessage, normalUser.dosingInstruction(normalCarbs, highCBG, normalFat, normalProtein));
        // Testing negative, zero, and edge cases
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(negativeCarbs, normalCBG, normalFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, negativeCBG, normalFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, zeroCBG, normalFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, extremeHighCBG, normalFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, extremeLowCBG, normalFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, normalCBG, negativeFat, normalProtein));
        assertThrows(IllegalArgumentException.class, () -> normalPumpUser.dosingInstruction(normalCarbs, normalCBG, normalFat, negativeProtein));
    }
}