package listeners;


import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;
import utils.appium.TakeScreenShot;
import utils.common.AllureUtils;
import utils.common.LogsUtils;
import utils.common.PropertiesUtils;

import java.io.File;

public class TestResultListener implements ITestListener {

    @Override
    public void onTestStart(ITestResult result) {
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        LogsUtils.info("Test passed: " + result.getName());
        AllureUtils.attachLogs(result);
    }

    @Override
    public void onTestFailure(ITestResult result) {
        LogsUtils.info("Test failed: " + result.getName());
        try {
            File screenshot = TakeScreenShot.takeScreenShot(result.getName() + "_Failed");
            if (screenshot != null) {
                AllureUtils.attachPng(screenshot);
            }
        } catch (Exception e) {
            LogsUtils.error("Failed to capture failure screenshot: " + e.getMessage());
        }
        AllureUtils.attachLogs(result);
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        LogsUtils.info("Test skipped: " + result.getName());
        AllureUtils.attachLogs(result);
    }

    @Override
    public void onStart(ITestContext context) {
        LogsUtils.info("Test run started");
        PropertiesUtils.loadProperties();
    }

    @Override
    public void onFinish(ITestContext context) {
        LogsUtils.info("Test run finished");
        PropertiesUtils.clearProperties();
    }
}
