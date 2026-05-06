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
        FileWriter writer = null;
        try {
            String datePrefix = _dateFormat.format(new Date());
            String entry = MessageFormat.format("{0}{1}{2}", datePrefix, MSG_SEPARATOR, message);
            File file = new File(filePath);
            if (!file.exists() && !file.createNewFile()) {
                throw new IOException(MessageFormat.format("Could not create file: {0}", filePath));
            }
            if (!file.setReadable(true, true)) {
                throw new IOException(MessageFormat.format("Could not set readable permission: {0}", filePath));
            }
            if (!file.setWritable(true, true)) {
                throw new IOException(MessageFormat.format("Could not set writable permission: {0}", filePath));
            }
            writer = new FileWriter(file, true);
            writer.write(String.format("%s%s", entry, NEW_LINE));
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

//    public String formatMessage(String message)
//    {
//        String datePrefix = _dateFormat.format(new Date());
//        return datePrefix + MSG_SEPARATOR + message;
//    }

    @Override
    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }
}
