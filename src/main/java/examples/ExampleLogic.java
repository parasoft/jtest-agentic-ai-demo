package examples;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ExampleLogic
{
    private final Lock _lock = new ReentrantLock();

    @Override
    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }


    public void appendString (String file, String data) throws IOException
    {
        File target = new File(file);
        if (!target.exists()) {
            if (!target.createNewFile()) {
                throw new IOException("Could not create requested file");
            }
        }
        if (!target.setReadable(true, true)) {
            throw new IOException("Could not set requested readable file permissions");
        }
        if (!target.setWritable(true, true)) {
            throw new IOException("Could not set requested writable file permissions");
        }
        try (FileWriter writer = new FileWriter(target, true)) {
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
