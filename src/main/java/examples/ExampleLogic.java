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
        File targetFile = new File(file);
        if (!targetFile.exists() && !targetFile.createNewFile()) {
            throw new IOException("Unable to create file");
        }
        if (!targetFile.setReadable(true, true) || !targetFile.setWritable(true, true)) {
            throw new IOException("Unable to set secure permissions for file");
        }
        try (FileWriter writer = new FileWriter(targetFile, true)) {
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

    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }
}
