package utils.common;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public class PropertiesUtils {

    private static final ThreadLocal<Properties> properties = new ThreadLocal<>();

    private static final String ANDROID_PATH =
            "src/main/resources/Env/AndroidEnv.properties";

    public static void loadProperties() {

        if (properties.get() == null) {

            Properties props = new Properties();

            LogsUtils.info(
                    "Loading Android properties from: " + ANDROID_PATH
            );

            try (InputStream is =
                         Files.newInputStream(Path.of(ANDROID_PATH))) {

                props.load(is);

                properties.set(props);

                LogsUtils.info(
                        "Android properties loaded successfully."
                );

            } catch (IOException e) {

                throw new RuntimeException(
                        "Failed to load Android properties.",
                        e
                );
            }
        }
    }

    public static String getProperty(
            String key,
            String defaultValue
    ) {

        Properties props = properties.get();

        if (props == null) {

            throw new IllegalStateException(
                    "Android properties have not been loaded yet."
            );
        }

        return props.getProperty(key, defaultValue);
    }

    public static String getProperty(String key) {
        return getProperty(key, null);
    }

    public static void clearProperties() {

        properties.remove();

        LogsUtils.info("Android properties cleared.");
    }
}