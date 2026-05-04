package examples;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.FileAttribute;
import java.nio.file.attribute.PosixFilePermission;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.EnumSet;
import java.util.Set;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ExampleLogic
{
    private final Lock lock = new ReentrantLock();

    @Override
    public final Object clone() throws CloneNotSupportedException
    {
        throw new CloneNotSupportedException();
    }

    public void appendString(String file, String data) throws IOException
    {
        Path filePath = Path.of(file).toAbsolutePath();
        if (Files.notExists(filePath)) {
            createFileWithSafePermissions(filePath);
        }

        Files.writeString(filePath, data, StandardOpenOption.WRITE, StandardOpenOption.APPEND);
    }

    private static void createFileWithSafePermissions(Path filePath) throws IOException
    {
        Path parent = filePath.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        if ((parent != null) && Files.getFileStore(parent).supportsFileAttributeView("posix")) {
            Set<PosixFilePermission> ownerOnly = EnumSet.of(
                PosixFilePermission.OWNER_READ,
                PosixFilePermission.OWNER_WRITE
            );
            FileAttribute<Set<PosixFilePermission>> attributes = PosixFilePermissions.asFileAttribute(ownerOnly);
            Files.createFile(filePath, attributes);
            return;
        }

        Files.createFile(filePath);

        File createdFile = filePath.toFile();
        boolean readableSet = createdFile.setReadable(true, true);
        boolean writableSet = createdFile.setWritable(true, true);
        boolean executableSet = createdFile.setExecutable(false, false);
        if (!readableSet || !writableSet || !executableSet) {
            String message = new StringBuilder("Failed to set secure file permissions for ")
                .append(filePath)
                .toString();
            throw new IOException(message);
        }
    }

    public void appendStringSafely(String file, String data) throws IOException, InterruptedException
    {
        lock.lock();
        try {
            appendString(file, data);
        } finally {
            lock.unlock();
        }
    }
}
