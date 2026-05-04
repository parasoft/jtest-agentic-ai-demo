package examples;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ExampleLogic
{
    private Lock _lock = new ReentrantLock();


    public void appendString (String file, String data) throws IOException
    {
        File f = new File(file);
        if (!f.exists()) {
            if (!f.createNewFile()) {
                throw new IOException("Failed to create file");
            }
        }
        if (!f.setWritable(true, true)) {
            throw new IOException("Failed to set writable permission on file");
        }
        if (!f.setReadable(true, true)) {
            throw new IOException("Failed to set readable permission on file");
        }
        try (FileWriter writer = new FileWriter(f, true)) {
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
