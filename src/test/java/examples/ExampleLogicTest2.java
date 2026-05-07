package examples;

import java.io.File;

import org.junit.Test;
/**
 * Parasoft Jtest UTA: Test class for ExampleLogic
 *
 * @see examples.ExampleLogic
 * @author mali
 */
public class ExampleLogicTest2
{

    /**
     * Parasoft Jtest UTA: Test for appendMessageToFile(File, String)
     *
     * @see examples.ExampleLogic#appendMessageToFile(File, String)
     * @author mali
     */
    @Test(timeout = 5000)
    public void testAppendMessageToFile() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();

        // When
        File file = File.createTempFile("file", null); // UTA: default value
        file.deleteOnExit();
        String message = "message"; // UTA: default value
        underTest.appendMessageToFile(file, message);

    }

    /**
     * Parasoft Jtest UTA: Test for clone()
     *
     * @see examples.ExampleLogic#clone()
     * @author mali
     */
    @Test(timeout = 5000, expected = CloneNotSupportedException.class)
    public void testClone() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();

        // When
        underTest.clone();

    }
}
