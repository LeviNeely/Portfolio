package assignment05;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class SpellCheckerTest {
    public SpellChecker sp;
    File file = new File("good_luck.txt");

    @BeforeEach
    void setUp() {
        sp = new SpellChecker();
    }

    @Test
    void addToDictionary() {
        sp.addToDictionary("bandaid");
        assertTrue(sp.getDictionary().contains("bandaid"));
        assertThrows(RuntimeException.class, () -> sp.addToDictionary(""));
    }

    @Test
    void removeFromDictionary() {
        assertFalse(sp.getDictionary().contains("bandaid"));
        sp.addToDictionary("bandaid");
        assertTrue(sp.getDictionary().contains("bandaid"));
    }

    @Test
    void spellCheck() {
        sp.addToDictionary("good");
        List<String> misspelledWords = sp.spellCheck(file);
        assertFalse(misspelledWords.contains("good"));
    }
}