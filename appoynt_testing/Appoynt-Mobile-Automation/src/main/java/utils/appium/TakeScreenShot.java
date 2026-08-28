package utils.appium;


import org.openqa.selenium.OutputType;
import org.openqa.selenium.UnhandledAlertException;
import utils.appium.driverManager.DriverManager;
import utils.common.DateTime;
import utils.common.LogsUtils;

import java.io.File;
import java.nio.file.Files;

public class TakeScreenShot {
    public static String SCREEN_SHOTS_PATH ="test_outputs/screenshots/";

    private TakeScreenShot() {
    }
    public static File takeScreenShot(String fileName) {
        File targetFile = null;
        LogsUtils.info("Taking screenshot for: " + fileName);
        try {
            File screenshot = DriverManager.getDriver().getScreenshotAs(OutputType.FILE);
            targetFile = new File(SCREEN_SHOTS_PATH + fileName + DateTime.getDateTime() + ".png");
            if (targetFile.getParentFile() != null && !targetFile.getParentFile().exists()) {
                targetFile.getParentFile().mkdirs();
            }
            Files.copy(screenshot.toPath(), targetFile.toPath());
            LogsUtils.info("Screenshot taken successfully: " + targetFile.getAbsolutePath());
            return targetFile;
        } catch (UnhandledAlertException e) {
            LogsUtils.warn("Skipping screenshot due to open alert: " + e.getAlertText());
            return null;
        } catch (Exception e) {
            LogsUtils.error("Failed to take screenshot: " + e.getMessage());
            return null;
        }
    }
}
