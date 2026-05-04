package examples;

import java.io.IOException;
import java.lang.reflect.Field;
import java.util.concurrent.locks.Lock;

import org.junit.Test;

import static org.mockito.Mockito.mock;
/**
 * Parasoft Jtest UTA: Test class for ExampleLogic
 *
 * @see examples.ExampleLogic
 * @author mali
 */
public class ExampleLogicTest2
{

    /**
     * Parasoft Jtest UTA: Test for appendString(String, String)
     *
     * @see examples.ExampleLogic#appendString(String, String)
     * @author mali
     */
    @Test(timeout = 5000)
    public void testAppendString() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();

        // When
        String file = "file"; // UTA: default value
        String data = "data"; // UTA: default value
        underTest.appendString(file, data);

    }

    /**
     * Parasoft Jtest UTA: Test for appendStringSafely(String, String)
     *
     * @see examples.ExampleLogic#appendStringSafely(String, String)
     * @author mali
     */
    @Test(timeout = 5000)
    public void testAppendStringSafely() throws Throwable
    {
        // Given
        ExampleLogic underTest = new ExampleLogic();
        Lock _lockValue = mock(Lock.class);
        setPrivateField(underTest, ExampleLogic.class, "_lock", _lockValue);

        // When
        String file = "file"; // UTA: default value
        String data = "data"; // UTA: default value
        underTest.appendStringSafely(file, data);

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
