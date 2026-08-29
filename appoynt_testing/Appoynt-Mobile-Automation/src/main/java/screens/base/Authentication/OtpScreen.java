package screens.base.Authentication;

import io.appium.java_client.AppiumBy;
import io.qameta.allure.Step;
import org.openqa.selenium.By;
import utils.appium.ElementsActions;
import utils.appium.Waits;

import java.time.Duration;

public abstract class OtpScreen {

    // Action buttons
    protected static final By verifyButton = AppiumBy.accessibilityId("Verify");
    protected static final By sendCodeAgainButton = AppiumBy.accessibilityId("Send code again");

    /**
     * Dynamic locator for any OTP input box by index (0 to 5 for 6-digit OTP).
     *
     * @param index 0-based index of the OTP input box
     * @return By locator for the specific OTP box
     */
    public static By getOtpBoxLocator(int index) {
        return AppiumBy.androidUIAutomator(
                "new UiSelector().className(\"android.widget.EditText\").instance(" + index + ")"
        );
    }

    @Step("Enter single OTP digit '{digit}' into box index {index}")
    public void enterOtpDigit(int index, String digit) {
        By boxLocator = getOtpBoxLocator(index);
        ElementsActions.setValue(boxLocator, digit);
    }

    @Step("Enter full OTP code: '{otpCode}'")
    public void enterOtp(String otpCode) {
        if (otpCode == null || otpCode.isEmpty()) {
            return;
        }
        // Wait uniquely for the OTP screen's Verify button to be visible
        Waits.waitForElementToBeVisible(verifyButton, Duration.ofSeconds(35));
        for (int i = 0; i < otpCode.length(); i++) {
            String digit = String.valueOf(otpCode.charAt(i));
            By boxLocator = getOtpBoxLocator(i);
            ElementsActions.setValue(boxLocator, digit);
        }
        ElementsActions.hideKeyboard();
    }

    @Step("Clear OTP box index {index}")
    public void clearOtpBox(int index) {
        By boxLocator = getOtpBoxLocator(index);
        ElementsActions.clear(boxLocator);
    }

    @Step("Clear all OTP boxes (up to {boxCount} boxes)")
    public void clearAllOtpBoxes(int boxCount) {
        for (int i = 0; i < boxCount; i++) {
            clearOtpBox(i);
        }
        ElementsActions.hideKeyboard();
    }

    @Step("Get value from OTP box index {index}")
    public String getOtpBoxValue(int index) {
        return ElementsActions.getValue(getOtpBoxLocator(index));
    }

    @Step("Tap 'Verify' button")
    public void tapVerify() {
        ElementsActions.hideKeyboard();
        Waits.waitForElementToBeVisible(verifyButton, Duration.ofSeconds(15));
        ElementsActions.click(verifyButton);
    }

    @Step("Tap 'Send code again' button")
    public void tapSendCodeAgain() {
        ElementsActions.click(sendCodeAgainButton);
    }

    @Step("Check if Verify button is enabled")
    public boolean isVerifyButtonEnabled() {
        ElementsActions.hideKeyboard();
        Waits.waitForElementToBeVisible(verifyButton, Duration.ofSeconds(5));
        return ElementsActions.isEnabled(verifyButton);
    }

    @Step("Check if Send code again button is enabled")
    public boolean isSendCodeAgainEnabled() {
        return ElementsActions.isEnabled(sendCodeAgainButton);
    }

    @Step("Check if OTP screen is displayed")
    public boolean isOtpScreenDisplayed() {
        return isOtpScreenDisplayed(35);
    }

    @Step("Wait for OTP screen to appear (up to {timeoutSeconds} seconds)")
    public boolean isOtpScreenDisplayed(int timeoutSeconds) {
        return Waits.isElementVisible(verifyButton, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(sendCodeAgainButton, Duration.ofSeconds(timeoutSeconds));
    }

    @Step("Check if error message is displayed: '{expectedMessage}'")
    public boolean isErrorMessageDisplayed(String expectedMessage) {
        return waitForErrorMessage(expectedMessage, 10);
    }

    @Step("Wait for Error message: '{expectedMessage}'")
    public boolean waitForErrorMessage(String expectedMessage, int timeoutSeconds) {
        By accId = AppiumBy.accessibilityId(expectedMessage);
        String textClean = expectedMessage.replace(".", "").replace("'", "");
        By descContains = AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"" + textClean + "\")");
        By textContains = AppiumBy.androidUIAutomator("new UiSelector().textContains(\"" + textClean + "\")");

        return Waits.isElementVisible(accId, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(descContains, Duration.ofSeconds(3))
                || Waits.isElementVisible(textContains, Duration.ofSeconds(3));
    }
}
