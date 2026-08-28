package utils.appium.driverManager;

import io.appium.java_client.AppiumDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import utils.appium.ServerManager;
import utils.common.LogsUtils;
import utils.common.PropertiesUtils;

import java.io.File;

public class AndroidFactory implements DriverFactory {

    @Override
    public AppiumDriver createDriver() {

        LogsUtils.info("Creating Android driver capabilities...");

        UiAutomator2Options options = new UiAutomator2Options();

        options.setPlatformName(
                PropertiesUtils.getProperty(
                        "platformName",
                        "Android"
                )
        );

        options.setPlatformVersion(
                PropertiesUtils.getProperty(
                        "platformVersion"
                )
        );

        options.setDeviceName(
                PropertiesUtils.getProperty(
                        "deviceName"
                )
        );

        options.setAutomationName(
                PropertiesUtils.getProperty(
                        "automationName",
                        "UiAutomator2"
                )
        );

        String appPath =
                PropertiesUtils.getProperty("appPath");

        File appFile = new File(appPath);

        if (!appFile.exists()) {

            throw new IllegalStateException(
                    "APK file was not found at: "
                            + appFile.getAbsolutePath()
            );
        }

        options.setApp(
                appFile.getAbsolutePath()
        );

        options.setSystemPort(
                Integer.parseInt(
                        PropertiesUtils.getProperty(
                                "systemPort",
                                "8200"
                        )
                )
        );

        options.setNoReset(
                Boolean.parseBoolean(
                        PropertiesUtils.getProperty("noReset", "true")
                )
        );

        options.setFullReset(
                Boolean.parseBoolean(
                        PropertiesUtils.getProperty("fullReset", "false")
                )
        );

        options.setAutoGrantPermissions(
                Boolean.parseBoolean(
                        PropertiesUtils.getProperty("autoGrantPermissions", "true")
                )
        );

        String dontStopAppOnReset = PropertiesUtils.getProperty("dontStopAppOnReset", "false");
        options.setCapability("appium:dontStopAppOnReset", Boolean.parseBoolean(dontStopAppOnReset));

        String forceAppLaunch = PropertiesUtils.getProperty("forceAppLaunch", "true");
        options.setCapability("appium:forceAppLaunch", Boolean.parseBoolean(forceAppLaunch));

        String appPackage = PropertiesUtils.getProperty("appPackage");
        if (appPackage != null && !appPackage.isBlank()) {
            options.setAppPackage(appPackage);
        }

        String appActivity = PropertiesUtils.getProperty("appActivity");
        if (appActivity != null && !appActivity.isBlank()) {
            options.setAppActivity(appActivity);
        }

        options.setUiautomator2ServerLaunchTimeout(java.time.Duration.ofSeconds(60));
        options.setUiautomator2ServerInstallTimeout(java.time.Duration.ofSeconds(60));
        options.setAdbExecTimeout(java.time.Duration.ofSeconds(60));

        try {
            new ProcessBuilder("adb", "forward", "--remove-all").start().waitFor();
        } catch (Exception ignored) {
        }

        LogsUtils.info(
                "Starting Appium session for device: "
                        + options.getDeviceName()
        );

        return new AppiumDriver(
                ServerManager.getServiceUrl(),
                options
        );
    }


    @Override
    public UiAutomator2Options setCapabilities() {

        UiAutomator2Options options =
                new UiAutomator2Options();

        options.setPlatformName(
                PropertiesUtils.getProperty(
                        "platformName",
                        "Android"
                )
        );

        options.setDeviceName(
                PropertiesUtils.getProperty(
                        "deviceName"
                )
        );

        options.setAutomationName(
                PropertiesUtils.getProperty(
                        "automationName",
                        "UiAutomator2"
                )
        );

        return options;
    }
}