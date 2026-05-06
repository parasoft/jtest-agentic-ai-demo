package examples;

import java.io.FileWriter;
import java.io.IOException;
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
            String entry = datePrefix + MSG_SEPARATOR + message;
            writer = new FileWriter(filePath, true);
            writer.write(entry + NEW_LINE);
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
}
