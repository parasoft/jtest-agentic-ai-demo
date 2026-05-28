package examples;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.locks.ReentrantLock;

public class ExampleLogic
{
    private ReentrantLock _lock = new ReentrantLock();
    private final static SimpleDateFormat _dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private final String MSG_SEPARATOR = ": ";
    private final String NEW_LINE = "\n";

    public void appendMessageToFile(File file, String message)
        throws IOException
    {
        _lock.lock();
        try (Writer writer = new FileWriter(file, Charset.defaultCharset(), true)) {
            String datePrefix = _dateFormat.format(new Date());
            String line = datePrefix + MSG_SEPARATOR + message + NEW_LINE;
            writer.write(line);
        }
        _lock.unlock();
    }

    public String formatHexSuffix(int randomValue)
    {
        return "_"+String.format("0x%04X", randomValue);
    }
}