package utils.android;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebElement;
import utils.appium.driverManager.DriverManager;

import java.util.HashMap;
import java.util.Map;

public class AndroidActions {

    //https://github.com/appium/appium-uiautomator2-driver/blob/master/docs/android-mobile-gestures.md

    public static void dragGesture(WebElement element, int endX, int endY) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("endX", endX);
        params.put("endY", endY);
        DriverManager.getDriver().executeScript("mobile: dragGesture", params);
    }
    public static void dragGesture(int startX, int startY, int endX, int endY) {
        Map<String, Object> params = new HashMap<>();
        params.put("startX", startX);
        params.put("startY", startY);
        params.put("endX", endX);
        params.put("endY", endY);
        DriverManager.getDriver().executeScript("mobile: dragGesture", params);
    }

    public static void flingGesture(WebElement element, String direction) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("direction", direction);
        DriverManager.getDriver().executeScript("mobile: flingGesture", params);
    }

    public static void doubleClickGesture(WebElement element) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        DriverManager.getDriver().executeScript("mobile: doubleClickGesture", params);
    }

    public static void doubleClickGesture(int x, int y) {
        Map<String, Object> params = new HashMap<>();
        params.put("x", x);
        params.put("y", y);
        DriverManager.getDriver().executeScript("mobile: doubleClickGesture", params);
    }

    public static void longClickGesture(WebElement element) {
        longClickGesture(element, 500);
    }

    public static void longClickGesture(int x, int y) {
        longClickGesture(x, y, 500);
    }

    public static void longClickGesture(int x, int y, int durationMs) {
        Map<String, Object> params = new HashMap<>();
        params.put("x", x);
        params.put("y", y);
        params.put("duration", durationMs);
        DriverManager.getDriver().executeScript("mobile: longClickGesture", params);
    }

    public static void longClickGesture(WebElement element, int durationMs) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("duration", durationMs);
        DriverManager.getDriver().executeScript("mobile: longClickGesture", params);
    }

    public static void pinchCloseGesture(WebElement element, double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: pinchCloseGesture", params);
    }

    public static void pinchCloseGesture(int left, int top,int width, int height , double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("left", left);
        params.put("top", top);
        params.put("width", width);
        params.put("height", height);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: pinchCloseGesture", params);
    }

    public static void pinchOpenGesture(WebElement element, double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: pinchOpenGesture", params);
    }

    public static void pinchOpenGesture(int left, int top,int width, int height , double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("left", left);
        params.put("top", top);
        params.put("width", width);
        params.put("height", height);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: pinchOpenGesture", params);
    }

    public static void swipeGesture(WebElement element, String direction, double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("direction", direction);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: swipeGesture", params);
    }

    public static void swipeGesture(int left, int top, int width, int height, String direction, double percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("left", left);
        params.put("top", top);
        params.put("width", width);
        params.put("height", height);
        params.put("direction", direction);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: swipeGesture", params);
    }

    public static void scrollGesture(WebElement element, String direction, int percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("elementId", ((RemoteWebElement) element).getId());
        params.put("direction", direction);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: scrollGesture", params);
    }

    public static void scrollGesture(int left, int top, int width, int height, String direction, int percent) {
        Map<String, Object> params = new HashMap<>();
        params.put("left", left);
        params.put("top", top);
        params.put("width", width);
        params.put("height", height);
        params.put("direction", direction);
        params.put("percent", percent);
        DriverManager.getDriver().executeScript("mobile: scrollGesture", params);
    }
    public static void scrollToElement(String UiSelector) {
        Map<String, Object> params = new HashMap<>();
        params.put("strategy", "-android uiautomator");
        params.put("selector", UiSelector);
        DriverManager.getDriver().executeScript("mobile: scroll", params);
    }


}
