package utils.appium.driverManager;

import io.appium.java_client.AppiumDriver;
import org.openqa.selenium.Capabilities;

public interface DriverFactory {

    AppiumDriver createDriver();

    Capabilities setCapabilities();
}