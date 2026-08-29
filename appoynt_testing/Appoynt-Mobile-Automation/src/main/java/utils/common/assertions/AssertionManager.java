package utils.common.assertions;

import org.testng.ITestResult;

public class AssertionManager {
    private static final ThreadLocal<CustomSoftAssert> customSoftAssertContainer =  ThreadLocal.withInitial(CustomSoftAssert::new);

    private static CustomSoftAssert getCustomSoftAssert() {
        return customSoftAssertContainer.get();
    }

    public static void assertAll(ITestResult testResult) {
        getCustomSoftAssert().customAssertAll(testResult);
        clearSoftAssert();
    }

    public static void clearSoftAssert() {
        customSoftAssertContainer.remove();
    }


    public static void assertEquals(Object actual, Object expected, String message) {
        getCustomSoftAssert().assertEquals(actual, expected, message);
    }


    public static void assertEquals(Object actual, Object expected) {
        getCustomSoftAssert().assertEquals(actual, expected);
    }


    public static void assertTrue(boolean condition, String message) {
        getCustomSoftAssert().assertTrue(condition, message);
    }


    public static void assertTrue(boolean condition) {
        getCustomSoftAssert().assertTrue(condition);
    }


    public static void assertFalse(boolean condition, String message) {
        getCustomSoftAssert().assertFalse(condition, message);
    }


    public static void assertFalse(boolean condition) {
        getCustomSoftAssert().assertFalse(condition);
    }
}
