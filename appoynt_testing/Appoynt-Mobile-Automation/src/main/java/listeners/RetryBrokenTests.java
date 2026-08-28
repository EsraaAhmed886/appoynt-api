package listeners;

import org.openqa.selenium.NoSuchElementException;
import org.openqa.selenium.TimeoutException;
import org.testng.IRetryAnalyzer;
import org.testng.ITestResult;


public class RetryBrokenTests implements IRetryAnalyzer {

    private int retryCount = 0;
    private static final int MAX_RETRIES = 1;

    @Override
    public boolean retry(ITestResult iTestResult) {
        Throwable cause = iTestResult.getThrowable();
        if ((cause instanceof NoSuchElementException)
                || (cause instanceof TimeoutException)) {
            if (retryCount < MAX_RETRIES) {
                retryCount++;
                return true;
            }
        }
        return false;
    }
}
