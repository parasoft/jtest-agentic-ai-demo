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
        File outputFile = new File(file);
        if (!outputFile.exists() && !outputFile.createNewFile()) {
            throw new IOException("Unable to create file.");
        }
        if (!outputFile.setReadable(true, true) || !outputFile.setWritable(true, true)) {
            throw new IOException("Unable to set secure file permissions.");
        }

        try (FileWriter writer = new FileWriter(outputFile, true)) {
            writer.write(data);
        }
    }

    public void appendStringSafely (String file, String data) throws IOException, InterruptedException
    {
        boolean lockAcquired = false;
        try {
            _lock.lock();
            lockAcquired = true;
            appendString(file, data);
        } finally {
            if (lockAcquired) {
                _lock.unlock();
            }
        }
    }

    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }
}
