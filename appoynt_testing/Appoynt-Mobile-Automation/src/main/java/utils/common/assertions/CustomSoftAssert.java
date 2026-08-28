package utils.common.assertions;

import org.testng.ITestResult;
import org.testng.Reporter;
import org.testng.asserts.IAssert;
import org.testng.asserts.SoftAssert;
import utils.common.AllureUtils;
import utils.common.LogsUtils;

import java.io.File;
import java.lang.reflect.Method;

import static utils.appium.TakeScreenShot.takeScreenShot;


class CustomSoftAssert extends SoftAssert {
    public CustomSoftAssert() {
        super();
    }

    public void customAssertAll(ITestResult result) {
        try {
            super.assertAll("Custom Soft Assertion");
        } catch (AssertionError e) {
            LogsUtils.error("Custom Soft Assertion Failed: " + e.getMessage());
            result.setStatus(ITestResult.FAILURE);
            result.setThrowable(e);}
    }


    @Override
    public void onAssertFailure(IAssert<?> assertCommand, AssertionError ex) {
        super.onAssertFailure(assertCommand, ex);
        Method testMethod = Reporter.getCurrentTestResult().getMethod().getConstructorOrMethod().getMethod();
        String testName = testMethod.getName();
        File screenshot = takeScreenShot(testName + "_Failed");
        LogsUtils.error("Assertion Failed: " + ex.getMessage());
        if (screenshot != null) {
            AllureUtils.attachPng(screenshot);
        }
    }



    @Override
    @Deprecated
    public void assertAll() {
        throw new UnsupportedOperationException(
                "Direct assertAll() is disabled; use customAssertAll() instead."
        );
    }

    @Override
    @Deprecated
    public void assertAll(String message) {
        throw new UnsupportedOperationException(
                "Direct assertAll(String) is disabled; use customAssertAll() instead."
        );
    }

}
