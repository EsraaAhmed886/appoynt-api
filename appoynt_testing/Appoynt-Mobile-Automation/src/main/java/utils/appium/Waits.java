package utils.appium;

import org.openqa.selenium.By;
import org.openqa.selenium.Point;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.FluentWait;
import org.openqa.selenium.support.ui.WebDriverWait;
import utils.appium.driverManager.DriverManager;

import java.time.Duration;

public class Waits {


    public static void waitForElementToBeVisible(By locator, Duration duration) {
        WebDriverWait wait = new WebDriverWait(DriverManager.getDriver(), duration);
        wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    public static void waitForElementToBeClickable(By locator, Duration duration) {
        WebDriverWait wait = new WebDriverWait(DriverManager.getDriver(), duration);
        wait.until(ExpectedConditions.elementToBeClickable(locator));
    }

    public static void waitForElementToBeInvisible(By locator, Duration duration) {
        WebDriverWait wait = new WebDriverWait(DriverManager.getDriver(), duration);
        wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    public static void waiForElessmentToBeStale(WebElement element, Duration duration) {
        WebDriverWait wait = new WebDriverWait(DriverManager.getDriver(), duration);
        wait.until(ExpectedConditions.stalenessOf(element));
    }


    public static void waitForElementToBeVisible(By locator, int seconds) {
        waitForElementToBeVisible(locator, Duration.ofSeconds(seconds));
    }

    public static void waitForElementToBeClickable(By locator, int seconds) {
        waitForElementToBeClickable(locator, Duration.ofSeconds(seconds));
    }

    public static boolean isElementVisible(By locator, Duration duration) {
        try {
            WebDriverWait wait = new WebDriverWait(DriverManager.getDriver(), duration);
            return wait.until(ExpectedConditions.visibilityOfElementLocated(locator)) != null;
        } catch (Exception e) {
            return false;
        }
    }

    public static void waitForElementToBeVisible(By locator) {
        waitForElementToBeVisible(locator, Duration.ofSeconds(Long.parseLong(System.getProperty("DefaultWaitTime", "20"))));
    }
    public static void waitForElementToBeClickable(By locator) {
        waitForElementToBeClickable(locator, Duration.ofSeconds(Long.parseLong(System.getProperty("DefaultWaitTime", "20"))));
    }
    public static void waitForElementToBeInvisible(By locator) {
        waitForElementToBeInvisible(locator, Duration.ofSeconds(Long.parseLong(System.getProperty("DefaultWaitTime", "20"))));
    }


    public static void waitForScrollToStop( By Locator, Duration timeout) {
    final Point[] prevLocation = {null};

    new FluentWait<>(DriverManager.getDriver())
        .withTimeout(timeout)
        .pollingEvery(Duration.ofMillis(500))
        .ignoring(Exception.class)
        .until(d -> {
            try {
                WebElement element = ElementsActions.findElement(Locator);
                Point currentLocation = element.getLocation();

                if (prevLocation[0] != null && prevLocation[0].equals(currentLocation)) {
                    return true;
                }
                prevLocation[0] = currentLocation;
                return false;

            } catch (Exception e) {
                return false;
            }
        });
    }

}
