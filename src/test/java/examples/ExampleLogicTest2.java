package examples;

import java.io.File;
import java.lang.reflect.Field;
import java.util.concurrent.locks.ReentrantLock;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
/**
 * Parasoft Jtest UTA: Test class for ExampleLogic
 *
 * @see examples.ExampleLogic
 * @author bmcglau
 */
public class ExampleLogicTest2
{

    /**
     * Parasoft Jtest UTA: Test for appendMessageToFile(File, String)
     *
     * @see examples.ExampleLogic#appendMessageToFile(File, String)
     * @author bmcglau
     */
    @Test(timeout = 5000)
    public void testAppendMessageToFile() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();
        ReentrantLock _lockValue = mock(ReentrantLock.class);
        setPrivateField(underTest, ExampleLogic.class, "_lock", _lockValue);

        // When
        File file = File.createTempFile("file", null); // UTA: default value
        file.deleteOnExit();
        String message = "message"; // UTA: default value
        underTest.appendMessageToFile(file, message);

    }

    /**
     * Parasoft Jtest UTA: Helper method to set private field _lock
     */
    private static <T> void setPrivateField(Object object, Class<?> fieldClass, String fieldName, T value)
    {
        try {
            Field field = fieldClass.getDeclaredField(fieldName);
            field.setAccessible(true);
            field.set(object, value);
        } catch (NoSuchFieldException e) {
            throw (AssertionError) new AssertionError("No such field found").initCause(e);
        } catch (IllegalAccessException e) {
            throw (AssertionError) new AssertionError("Unable to access the specified private field").initCause(e);
        } catch (SecurityException e) {
            throw (AssertionError) new AssertionError("There was a security exception when attempting to access a private field").initCause(e);
        }
    }

    /**
     * Parasoft Jtest UTA: Test for formatHexSuffix(int)
     *
     * @see examples.ExampleLogic#formatHexSuffix(int)
     * @author bmcglau
     */
    @Test(timeout = 5000)
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
