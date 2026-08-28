package utils.appium;

import io.appium.java_client.service.local.AppiumDriverLocalService;
import io.appium.java_client.service.local.AppiumServiceBuilder;

import java.net.URL;

public class ServerManager {
    private static AppiumDriverLocalService instance;

    private static AppiumDriverLocalService getInstance() {
        if (instance == null) {
            AppiumServiceBuilder builder = new AppiumServiceBuilder()
                    .withIPAddress("127.0.0.1")
                    .usingPort(4723)
                    .withArgument(() -> "--log-no-colors")
                    .withArgument(() -> "--allow-insecure", "*:get_server_logs");
            instance = builder.build();
        }
        return instance;
    }

    public static void startService() {
        try {
            if (instance == null || !instance.isRunning()) {
                getInstance().start();
            }
        } catch (Exception e) {
            utils.common.LogsUtils.warn("Local Appium service not started (server might already be running): " + e.getMessage());
        }
    }

    public static void stopService() {
        try {
            if (instance != null && instance.isRunning()) {
                instance.stop();
            }
        } catch (Exception ignored) {
        }
    }

    public static URL getServiceUrl() {
        try {
            return java.net.URI.create("http://127.0.0.1:4723").toURL();
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }
}
