package examples;

import java.io.FileWriter;
import java.io.IOException;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ExampleLogic
{
    private Lock _lock = new ReentrantLock();


    public void appendString (String file, String data) throws IOException
    {
        try (FileWriter writer = new FileWriter(file, true)) {
            writer.write(data);
        }
    }

    public void appendStringSafely (String file, String data) throws IOException, InterruptedException
    {
        _lock.lock();
        try {
            appendString(file, data);
        } finally {
            _lock.unlock();
        }
    }
}
