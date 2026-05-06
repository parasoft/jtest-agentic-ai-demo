package examples;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ExampleLogic
{
    private final String MSG_SEPARATOR = ": ";
    private final String NEW_LINE = "\n";

    private final static SimpleDateFormat _dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


    public void appendMessageToFile(String filePath, String message)
        throws IOException
    {
        if (filePath == null || filePath.isEmpty()) {
            throw new IllegalArgumentException("Message cannot be null or empty");
        }
        if (message == null || message.isEmpty()) {
            throw new IllegalArgumentException("Message cannot be null or empty");
        }

        FileWriter writer = null;
        try {
            String datePrefix = _dateFormat.format(new Date());
            File outputFile = new File(filePath);
            if (!outputFile.exists() && outputFile.createNewFile()) {
                if (!outputFile.setReadable(true, true)) {
                    throw new IOException(MessageFormat.format("Failed to set read permission on file: {0}", filePath));
                }
                if (!outputFile.setWritable(true, true)) {
                    throw new IOException(MessageFormat.format("Failed to set write permission on file: {0}", filePath));
                }
            }
            writer = new FileWriter(outputFile, true);
            writer.write(datePrefix);
            writer.write(MSG_SEPARATOR);
            writer.write(message);
            writer.write(NEW_LINE);
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }


        public String formatMessage(String message)
        {
            String datePrefix = _dateFormat.format(new Date());
            return MessageFormat.format("{0}{1}{2}", datePrefix, MSG_SEPARATOR, message);
        }

    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }
}
