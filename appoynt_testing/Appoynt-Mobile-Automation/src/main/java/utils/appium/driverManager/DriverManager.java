package utils.appium.driverManager;

import io.appium.java_client.AppiumDriver;
import utils.common.LogsUtils;

public class DriverManager {

    private static final ThreadLocal<AppiumDriver> driver =
            new ThreadLocal<>();


    public static void initDriver() {

        if (driver.get() == null) {

            LogsUtils.info("Initializing Android driver...");

            driver.set(
                    new AndroidFactory().createDriver()
            );

            LogsUtils.info(
                    "Android driver initialized successfully."
            );
        }
    }


    public static AppiumDriver getDriver() {

        AppiumDriver appiumDriver = driver.get();

        if (appiumDriver == null) {

            throw new IllegalStateException(
                    "Driver is not initialized. " +
                            "Make sure DriverManager.initDriver() " +
                            "is called before running the test."
            );
        }

        return appiumDriver;
    }


    public static void quitDriver() {

        AppiumDriver appiumDriver = driver.get();

        if (appiumDriver != null) {

            LogsUtils.info("Quitting Android driver...");

            appiumDriver.quit();

            driver.remove();
        }
    }


    public static void setDriver(
            AppiumDriver appiumDriver
    ) {

        driver.set(appiumDriver);
    }
}