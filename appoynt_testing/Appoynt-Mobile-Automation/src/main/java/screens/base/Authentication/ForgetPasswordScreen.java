package screens.base.Authentication;

import io.appium.java_client.AppiumBy;
import io.qameta.allure.Step;
import org.openqa.selenium.By;
import utils.appium.ElementsActions;
import utils.appium.Waits;

import java.time.Duration;

public abstract class ForgetPasswordScreen {

    // ==========================================
    // Step 1: Phone Input Locators
    // ==========================================
    protected static final By phoneField =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.EditText\").instance(0)"
            );

    protected static final By sendCodeButton =
            AppiumBy.accessibilityId("Send Code");

    // ==========================================
    // Step 2: OTP Locators
    // ==========================================
    protected static final By verifyOtpButton =
            AppiumBy.accessibilityId("Verify");

    protected static final By sendCodeAgainButton =
            AppiumBy.accessibilityId("Send code again");

    // ==========================================
    // Step 3: New Password Locators
    // ==========================================
    protected static final By newPasswordField =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.EditText\").instance(0)"
            );

    protected static final By confirmPasswordField =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.EditText\").instance(1)"
            );

    protected static final By updatePasswordButton =
            AppiumBy.accessibilityId("Update Password");

    // ==========================================
    // Step 1 Actions (Phone Number)
    // ==========================================

    @Step("Enter Phone Number: {phoneNumber}")
    public void enterPhoneNumber(String phoneNumber) {
        ElementsActions.setValue(phoneField, phoneNumber);
    }

    @Step("Clear Phone Number field")
    public void clearPhoneNumber() {
        ElementsActions.clear(phoneField);
    }

    @Step("Get Phone Number field value")
    public String getPhoneNumberValue() {
        return ElementsActions.getValue(phoneField);
    }

    @Step("Tap 'Send Code' button")
    public void tapSendCode() {
        ElementsActions.hideKeyboard();
        ElementsActions.click(sendCodeButton);
    }

    @Step("Check if 'Send Code' button is enabled")
    public boolean isSendCodeButtonEnabled() {
        ElementsActions.hideKeyboard();
        return ElementsActions.isEnabled(sendCodeButton);
    }

    @Step("Check if on Phone Number step")
    public boolean isPhoneStepDisplayed() {
        return Waits.isElementVisible(phoneField, Duration.ofSeconds(10))
                && Waits.isElementVisible(sendCodeButton, Duration.ofSeconds(5));
    }

    // ==========================================
    // Step 2 Actions (OTP Verification)
    // ==========================================

    /**
     * Dynamic helper to locate OTP digit box by index (0 to 5).
     */
    public static By getOtpBoxLocator(int index) {
        return OtpScreen.getOtpBoxLocator(index);
    }

    @Step("Enter OTP digit '{digit}' at box {index}")
    public void enterOtpDigit(int index, String digit) {
        ElementsActions.setValue(getOtpBoxLocator(index), digit);
    }

    @Step("Enter full OTP code: '{otpCode}'")
    public void enterOtp(String otpCode) {
        if (otpCode == null || otpCode.isEmpty()) {
            return;
        }
        for (int i = 0; i < otpCode.length(); i++) {
            String digit = String.valueOf(otpCode.charAt(i));
            ElementsActions.setValue(getOtpBoxLocator(i), digit);
        }
        ElementsActions.hideKeyboard();
    }

    @Step("Clear OTP box {index}")
    public void clearOtpBox(int index) {
        ElementsActions.clear(getOtpBoxLocator(index));
    }

    @Step("Tap 'Verify' OTP button")
    public void tapVerifyOtp() {
        ElementsActions.hideKeyboard();
        ElementsActions.click(verifyOtpButton);
    }

    @Step("Tap 'Send code again' button")
    public void tapSendCodeAgain() {
        ElementsActions.click(sendCodeAgainButton);
    }

    @Step("Check if 'Verify' OTP button is enabled")
    public boolean isVerifyOtpButtonEnabled() {
        ElementsActions.hideKeyboard();
        Waits.waitForElementToBeVisible(verifyOtpButton, Duration.ofSeconds(5));
        return ElementsActions.isEnabled(verifyOtpButton);
    }

    @Step("Check if 'Send code again' button is enabled")
    public boolean isSendCodeAgainButtonEnabled() {
        return ElementsActions.isEnabled(sendCodeAgainButton);
    }

    @Step("Check if on OTP step")
    public boolean isOtpStepDisplayed() {
        return waitForOtpStep(30);
    }

    @Step("Wait for OTP step (up to {timeoutSeconds}s)")
    public boolean isOtpStepDisplayed(int timeoutSeconds) {
        return waitForOtpStep(timeoutSeconds);
    }

    @Step("Wait for OTP step (up to {timeoutSeconds}s)")
    public boolean waitForOtpStep(int timeoutSeconds) {
        return Waits.isElementVisible(getOtpBoxLocator(0), Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(verifyOtpButton, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Enter your code"), Duration.ofSeconds(timeoutSeconds));
    }

    // ==========================================
    // Step 3 Actions (Reset / Update Password)
    // ==========================================

    @Step("Enter New Password")
    public void setNewPassword(String newPassword) {
        ElementsActions.setValue(newPasswordField, newPassword);
    }

    @Step("Enter Confirm Password")
    public void setConfirmPassword(String confirmPassword) {
        ElementsActions.setValue(confirmPasswordField, confirmPassword);
    }

    @Step("Set both New Password and Confirm Password")
    public void setNewAndConfirmPassword(String newPassword, String confirmPassword) {
        setNewPassword(newPassword);
        setConfirmPassword(confirmPassword);
        ElementsActions.hideKeyboard();
    }

    @Step("Tap 'Update Password' button")
    public void tapUpdatePassword() {
        ElementsActions.hideKeyboard();
        try {
            ElementsActions.click(updatePasswordButton);
        } catch (Exception e) {
            try {
                ElementsActions.click(AppiumBy.accessibilityId("Update"));
            } catch (Exception ex) {
                ElementsActions.click(AppiumBy.accessibilityId("Reset Password"));
            }
        }
    }

    @Step("Check if 'Update Password' button is enabled")
    public boolean isUpdatePasswordButtonEnabled() {
        ElementsActions.hideKeyboard();
        try {
            return ElementsActions.isEnabled(updatePasswordButton);
        } catch (Exception e) {
            return ElementsActions.isEnabled(AppiumBy.accessibilityId("Update"));
        }
    }

    @Step("Check if on Reset Password step")
    public boolean isResetPasswordStepDisplayed() {
        return waitForResetPasswordStep(30);
    }

    @Step("Wait for Reset Password step (up to {timeoutSeconds}s)")
    public boolean waitForResetPasswordStep(int timeoutSeconds) {
        return Waits.isElementVisible(newPasswordField, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(updatePasswordButton, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Update"), Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Reset Password"), Duration.ofSeconds(timeoutSeconds));
    }

    // ==========================================
    // Common Verifications & Dynamic Errors
    // ==========================================

    @Step("Check if Error message is displayed: '{expectedMessage}'")
    public boolean isErrorMessageDisplayed(String expectedMessage) {
        return waitForErrorMessage(expectedMessage, 10);
    }

    @Step("Wait for Error message to appear: '{expectedMessage}'")
    public boolean waitForErrorMessage(String expectedMessage, int timeoutSeconds) {
        By accId = AppiumBy.accessibilityId(expectedMessage);
        String textClean = expectedMessage.replace(".", "").replace("'", "");
        By descContains = AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"" + textClean + "\")");
        By textContains = AppiumBy.androidUIAutomator("new UiSelector().textContains(\"" + textClean + "\")");

        return Waits.isElementVisible(accId, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(descContains, Duration.ofSeconds(3))
                || Waits.isElementVisible(textContains, Duration.ofSeconds(3));
    }

    @Step("Wait for Success message / Header: '{expectedMessage}'")
    public boolean waitForSuccessMessage(String expectedMessage, int timeoutSeconds) {
        return waitForErrorMessage(expectedMessage, timeoutSeconds);
    }
}
