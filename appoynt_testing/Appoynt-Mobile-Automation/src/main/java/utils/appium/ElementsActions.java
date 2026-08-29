package utils.appium;


import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import utils.appium.driverManager.DriverManager;
import utils.common.LogsUtils;

import java.util.ArrayList;
import java.util.List;

public class ElementsActions {
    public static List<WebElement> findElements(By... locators ) {
        List<WebElement> allElements = new ArrayList<>();
        for(By locator : locators) {
           List <WebElement> elements = DriverManager.getDriver().findElements(locator);
           allElements.addAll(elements);
        }
        return allElements;
    
    }

    public static WebElement findElement(By locator) {
        Waits.waitForElementToBeVisible(locator);
        return DriverManager.getDriver().findElement(locator);
    }

    public static void setValue(By locator, String value) {
        WebElement element = findElement(locator);
        element.click();
        element.clear();
        element.sendKeys(value);
        hideKeyboard();
    }

    public static void click(By locator) {
        Waits.waitForElementToBeClickable(locator);
        WebElement element = findElement(locator);
        element.click();
    }

    public static String getText(By locator) {
        if (isDisplayed(locator)) {
            WebElement element = findElement(locator);
            return element.getText();
        }
        LogsUtils.warn("Element not displayed: " + locator);
        return "";
    }

    public static String getAttribute(By locator, String attributeName) {
        if (isDisplayed(locator)) {
            WebElement element = findElement(locator);
            return element.getAttribute(attributeName);
        }
        LogsUtils.warn("Element not displayed: " + locator);
        return "";
    }

    public static boolean isDisplayed(By locator) {
        try {
            WebElement element = findElement(locator);
            return element.isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public static boolean isEnabled(By locator) {
        try {
            WebElement element = DriverManager.getDriver().findElement(locator);
            String enabledAttr = element.getAttribute("enabled");
            String clickableAttr = element.getAttribute("clickable");
            return element.isEnabled()
                    || "true".equalsIgnoreCase(enabledAttr)
                    || "true".equalsIgnoreCase(clickableAttr);
        } catch (Exception e) {
            return false;
        }
    }

    public static void clear(By locator) {
        try {
            WebElement element = findElement(locator);
            element.click();
            element.clear();
            hideKeyboard();
        } catch (Exception e) {
            LogsUtils.warn("Could not clear element: " + locator + ". " + e.getMessage());
        }
    }

    public static String getValue(By locator) {
        String text = getText(locator);
        if (text != null && !text.isEmpty()) {
            return text;
        }
        String attributeText = getAttribute(locator, "text");
        return attributeText != null ? attributeText : "";
    }

    public static void hideKeyboard() {
        try {
            if (DriverManager.getDriver() instanceof io.appium.java_client.HidesKeyboard hidesKeyboard) {
                hidesKeyboard.hideKeyboard();
            }
        } catch (Exception ignored) {
            try {
                if (DriverManager.getDriver() instanceof io.appium.java_client.android.AndroidDriver androidDriver) {
                    androidDriver.pressKey(
                            new io.appium.java_client.android.nativekey.KeyEvent(
                                    io.appium.java_client.android.nativekey.AndroidKey.BACK
                            )
                    );
                }
            } catch (Exception ignored2) {
            }
        }
    }

    public static void scrollDown() {
        try {
            org.openqa.selenium.Dimension size = DriverManager.getDriver().manage().window().getSize();
            int startX = size.width / 2;
            int startY = (int) (size.height * 0.70);
            int endY = (int) (size.height * 0.25);

            org.openqa.selenium.interactions.PointerInput finger =
                    new org.openqa.selenium.interactions.PointerInput(org.openqa.selenium.interactions.PointerInput.Kind.TOUCH, "finger");
            org.openqa.selenium.interactions.Sequence swipe =
                    new org.openqa.selenium.interactions.Sequence(finger, 1);

            swipe.addAction(finger.createPointerMove(java.time.Duration.ZERO, org.openqa.selenium.interactions.PointerInput.Origin.viewport(), startX, startY));
            swipe.addAction(finger.createPointerDown(org.openqa.selenium.interactions.PointerInput.MouseButton.LEFT.asArg()));
            swipe.addAction(finger.createPointerMove(java.time.Duration.ofMillis(400), org.openqa.selenium.interactions.PointerInput.Origin.viewport(), startX, endY));
            swipe.addAction(finger.createPointerUp(org.openqa.selenium.interactions.PointerInput.MouseButton.LEFT.asArg()));

            DriverManager.getDriver().perform(java.util.Collections.singletonList(swipe));
        } catch (Exception e) {
            LogsUtils.warn("Scroll down failed: " + e.getMessage());
        }
    }
}
