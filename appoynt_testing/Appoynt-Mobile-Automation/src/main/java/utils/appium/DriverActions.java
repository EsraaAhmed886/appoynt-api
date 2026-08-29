package utils.appium;


import utils.appium.driverManager.DriverManager;

public class DriverActions {

    public static void back(){
        DriverManager.getDriver().navigate().back();
    }
    public static void forward(){
        DriverManager.getDriver().navigate().forward();
    }
    public static void refresh(){
        DriverManager.getDriver().navigate().refresh();
    }

    public static String getCurrentUrl() {
        return DriverManager.getDriver().getCurrentUrl();
    }

}
