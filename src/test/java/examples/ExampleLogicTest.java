package examples;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.locks.ReentrantLock;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;
import org.junit.jupiter.api.Timeout.ThreadMode;
import org.junit.jupiter.api.io.TempDir;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.mock;
class ExampleLogicTest
{
    @TempDir
    Path tempDir;

    @Test
    void appendString_writesDataToFile() throws IOException
    {
        ExampleLogic logic = new ExampleLogic();
        Path file = tempDir.resolve("test.txt");

        logic.appendMessageToFile(file.toFile(), "Hello");

        String content = Files.readString(file);
        assertTrue(content.contains("Hello"));
    }

    /**
     * Parasoft Jtest UTA: Test for formatHexSuffix(int)
     *
     * @see examples.ExampleLogic#formatHexSuffix(int)
     * @author mali
     */
    @Test
    @Timeout(value = 5, threadMode = ThreadMode.SEPARATE_THREAD)
    public void testFormatHexSuffix() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();

        // When
        int randomValue = 1; // UTA: default value
        String result = underTest.formatHexSuffix(randomValue);

        // Then - assertions for result of method formatHexSuffix(int)
        assertEquals("_0x0001", result);

    }
}