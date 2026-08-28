package utils.common;



import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FilesUtils {


    public static Path getLatestFile(Path folder) {
        if (!Files.isDirectory(folder)) {
            LogsUtils.warn("Directory not found: " + folder);
            return null;
        }
        Path latest = null;
        long highestModTime = 0L;
        try (DirectoryStream<Path> ds = Files.newDirectoryStream(folder)) {
            for (Path file : ds) {
                if (Files.isRegularFile(file)) {
                    try {
                        long fileModTime = Files.getLastModifiedTime(file).toMillis();
                        if (fileModTime > highestModTime) {
                            highestModTime = fileModTime;
                            latest = file;
                        }
                    } catch (IOException e) {
                        LogsUtils.error("Cannot read last-modified time of " + file + ": " + e.getMessage());
                    }
                }
            }
        } catch (IOException e) {
            LogsUtils.error("Failed to open directory " + folder + ": " + e.getMessage());
            return null;
        }
        if (latest != null) {
            LogsUtils.info("Found latest file in " + folder + ": " + latest);
        } else {
            LogsUtils.warn("No  files found in " + folder);
        }
        return latest;
    }




    public static List<Path> getLatestFiles(Path folder, long thresholdMillis) {
        if (!Files.isDirectory(folder)) {
            LogsUtils.warn("Directory not found: " + folder);
            return Collections.emptyList();
        }
        List<Path> result = new ArrayList<>();
        long newest = 0L;

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(folder, Files::isRegularFile)) {
            for (Path p : stream) {
                BasicFileAttributes attrs = Files.readAttributes(p, BasicFileAttributes.class);
                long ct = attrs.creationTime().toMillis();
                if (ct > newest) {
                    newest = ct;
                }
            }
        } catch (IOException e) {
            LogsUtils.error("Failed to read directory: " + folder + ". Error: " + e.getMessage());
            return Collections.emptyList();
        }
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(folder, Files::isRegularFile)) {
            for (Path p : stream) {
                BasicFileAttributes attrs = Files.readAttributes(p, BasicFileAttributes.class);
                long ct = attrs.creationTime().toMillis();
                if (newest - ct <= thresholdMillis) {
                    result.add(p);
                }
            }
        } catch (IOException e) {
            LogsUtils.error("Failed to read directory: " + folder + ". Error: " + e.getMessage());
            return Collections.emptyList();
        }

        LogsUtils.info("Found " + result.size() + " files within " + thresholdMillis + "ms threshold in " + folder);
        return result;
    }



    public static void deleteFileContent(File folder) {
        LogsUtils.info("Deleting files or folders in: " + folder.getAbsolutePath());
        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    deleteFileContent(file);
                }
                if (!file.delete()) {
                    LogsUtils.warn("Failed to delete file: " + file.getAbsolutePath());
                }
            }
        }
    }
    public static void deleteFileContent(File folder, String except) {
        LogsUtils.info("Deleting files or folders in: " + folder.getAbsolutePath());
        File[] files = folder.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.getName().equals(except)) {
                    continue;
                }
                if (file.isDirectory()) {
                    deleteFileContent(file);
                }
                if (!file.delete()) {
                    LogsUtils.warn("Failed to delete: " + file.getAbsolutePath());
                }
            }
        }
    }




    public static Path renameFile(Path source, Path target) {
        if (source == null || target == null) {
            LogsUtils.warn("Source or target or both path are null: " + source + " -> " + target);
            return null;
        }
        try {
            Path renamedPath = Files.move(source, target, StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.ATOMIC_MOVE);
            LogsUtils.info("File renamed successfully from " + source + " to " + target);
            return renamedPath;
        } catch (IOException e) {
            LogsUtils.warn("Failed to rename file from " + source + " to " + target + ": " + e.getMessage());
            return null;
        }
    }

    
    public static Path createDirectoryIfNeeded(Path dir) {
        if (dir == null) {
            LogsUtils.warn("Directory path is null");
            return null;
        }
        if (Files.exists(dir)) {
            LogsUtils.info("Directory already exists: " + dir);
            return dir;
        }
        try {
            Path createdDir = Files.createDirectories(dir);
            LogsUtils.info("Directory created successfully: " + createdDir);
            return createdDir;
        } catch (IOException e) {
            LogsUtils.warn("Failed to create directory: " + dir + " — " + e.getMessage());
            return null;
        }
    }


    public static Path createDirectoryIfNeeded(String dir) {
        return createDirectoryIfNeeded(Paths.get(dir));
    }
    public static Path renameFile(String source, String target) {
        return renameFile(Paths.get(source), Paths.get(target));
    }
    public static void deleteFileContent(String folder) {
        deleteFileContent(new File(folder));
    }
    public static List<Path> getLatestFiles( String folderPath, long thresholdMillis) {
        return getLatestFiles( Paths.get(folderPath) , thresholdMillis);
    }
    public static Path getLatestFile(String folderPath) {
        return getLatestFile(Paths.get(folderPath));
    }
    public static void deleteFileContent(String folder, String except){
        deleteFileContent(new File(folder),except);
    }
}

