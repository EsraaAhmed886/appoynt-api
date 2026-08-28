package utils.common;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public class SystemProperties {
   private static final String TEST_PROPERTIES_PATH = "src/main/resources/testConfiguration.properties";

    private static boolean isLoaded = false;

    public static synchronized void load() {
        if (isLoaded) {
            return;
        }
        Properties props = new Properties();
        try (InputStream is = Files.newInputStream(Path.of(TEST_PROPERTIES_PATH))) {
            props.load(is);
            props.forEach((key, value) -> System.setProperty(key.toString(), value.toString()));
            isLoaded = true;
        } catch (IOException e) {
            System.err.println("Failed to load system properties from " + TEST_PROPERTIES_PATH + ": " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
}
