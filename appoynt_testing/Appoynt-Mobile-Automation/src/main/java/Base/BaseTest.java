package Base;

import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import utils.appium.driverManager.DriverManager;
import utils.common.PropertiesUtils;

public class BaseTest {

    @BeforeMethod(alwaysRun = true)
    public void setUp() {

        // 1. Load Android properties first
        PropertiesUtils.loadProperties();

        // 2. Initialize Appium driver
        DriverManager.initDriver();

        // 3. Handle Onboarding/Landing Screen with Skip Button
        handleOnboardingSkip();
    }

    private void handleOnboardingSkip() {
        try {
            org.openqa.selenium.By skipButton = io.appium.java_client.AppiumBy.accessibilityId("Skip");
            if (utils.appium.Waits.isElementVisible(skipButton, java.time.Duration.ofSeconds(10))) {
                utils.appium.ElementsActions.click(skipButton);
            }
        } catch (Exception ignored) {
        }
    }


    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        try {
            // Quit driver
            DriverManager.quitDriver();
        } catch (Exception e) {
            utils.common.LogsUtils.warn("Error quitting driver: " + e.getMessage());
        } finally {
            // Clear properties
            PropertiesUtils.clearProperties();
        }
    }
}