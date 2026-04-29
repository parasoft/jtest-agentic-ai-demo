package examples;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class ExampleLogicTest {

    @TempDir
    Path tempDir;

    @Test
    void appendString_writesDataToFile() throws IOException {
        ExampleLogic logic = new ExampleLogic();
        Path file = tempDir.resolve("test.txt");

        logic.appendString(file.toString(), "Hello");

        String content = Files.readString(file);
        assertEquals("Hello", content);
    }
}

