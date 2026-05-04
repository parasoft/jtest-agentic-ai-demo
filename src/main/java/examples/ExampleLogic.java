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
        _lock.lock();
        try {
            try (FileWriter writer = new FileWriter(file, true)) {
                writer.write(data);
            }
        } finally {
            _lock.unlock();
        }
    }

    public int add(int x, int y)
    {
        return x + y;
    }
}
