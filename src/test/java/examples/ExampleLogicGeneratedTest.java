package examples;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

/**
 * Parasoft Jtest UTA: Test class for ExampleLogic
 *
 * @see examples.ExampleLogic
 * @author mali
 */
public class ExampleLogicGeneratedTest
{
    @TempDir
    Path tempDir;

    /**
     * Parasoft Jtest UTA: Test for appendString(String, String)
     *
     * @see examples.ExampleLogic#appendString(String, String)
     * @author mali
     */
    @Test
    public void testAppendString() throws IOException
    {
        ExampleLogic underTest = new ExampleLogic();
        Path file = tempDir.resolve("appendString.txt");

        underTest.appendString(file.toString(), "data");

        assertEquals("data", Files.readString(file));
    }

    /**
     * Parasoft Jtest UTA: Test for appendStringSafely(String, String)
     *
     * @see examples.ExampleLogic#appendStringSafely(String, String)
     * @author mali
     */
    @Test
    public void testAppendStringSafely() throws IOException, InterruptedException
    {
        ExampleLogic underTest = new ExampleLogic();
        Path file = tempDir.resolve("appendStringSafely.txt");

        underTest.appendStringSafely(file.toString(), "data");

        assertEquals("data", Files.readString(file));
    }

    /**
     * Parasoft Jtest UTA: Test for clone()
     *
     * @see examples.ExampleLogic#clone()
     * @author mali
     */
    @Test
    public void testClone()
    {
        ExampleLogic underTest = new ExampleLogic();

        assertThrows(CloneNotSupportedException.class, underTest::clone);
    }

}
