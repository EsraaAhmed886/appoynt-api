package screens.base.Authentication;

import io.appium.java_client.AppiumBy;
import io.qameta.allure.Step;
import org.openqa.selenium.By;
import utils.appium.ElementsActions;
import utils.appium.Waits;

import java.time.Duration;

public abstract class RegisterScreen {

    // ==========================================
    // Registration Form Locators
    // ==========================================
    protected static final By firstNameField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(0)");

    protected static final By lastNameField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(1)");

    protected static final By emailField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(2)");

    protected static final By phoneField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(3)");

    protected static final By passwordField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(4)");

    protected static final By confirmPasswordField =
            AppiumBy.androidUIAutomator("new UiSelector().className(\"android.widget.EditText\").instance(5)");

    protected static final By termsCheckbox =
            AppiumBy.accessibilityId("I agree to the Terms & Conditions and Privacy Policy");

    protected static final By createAccountButton =
            AppiumBy.accessibilityId("Create My Account");

    // ==========================================
    // Registration Success Locators
    // ==========================================
    protected static final By successTitle =
            AppiumBy.accessibilityId("Account Created Successfully!");

    protected static final By goToHomeButton =
            AppiumBy.accessibilityId("Go to Home");

    // ==========================================
    // Registration Form Actions
    // ==========================================

    @Step("Enter First Name: '{firstName}'")
    public void setFirstName(String firstName) {
        ElementsActions.setValue(firstNameField, firstName);
    }

    @Step("Enter Last Name: '{lastName}'")
    public void setLastName(String lastName) {
        ElementsActions.setValue(lastNameField, lastName);
    }

    @Step("Enter Email: '{email}'")
    public void setEmail(String email) {
        ElementsActions.setValue(emailField, email);
    }

    @Step("Enter Phone Number: '{phone}'")
    public void setPhone(String phone) {
        ElementsActions.setValue(phoneField, phone);
    }

    @Step("Enter Password: '{password}'")
    public void setPassword(String password) {
        ElementsActions.setValue(passwordField, password);
    }

    @Step("Enter Confirm Password: '{confirmPassword}'")
    public void setConfirmPassword(String confirmPassword) {
        ElementsActions.setValue(confirmPasswordField, confirmPassword);
    }

    @Step("Toggle Terms & Conditions Checkbox")
    public void acceptTerms() {
        ElementsActions.hideKeyboard();
        ElementsActions.click(termsCheckbox);
        ElementsActions.scrollDown();
    }

    @Step("Fill complete Registration Form")
    public void fillRegistrationForm(String firstName, String lastName, String email, String phone, String password, String confirmPassword) {
        setFirstName(firstName);
        setLastName(lastName);
        setEmail(email);
        setPhone(phone);
        setPassword(password);
        setConfirmPassword(confirmPassword);
        ElementsActions.hideKeyboard();
    }

    @Step("Tap 'Create My Account' button")
    public void tapCreateAccount() {
        ElementsActions.hideKeyboard();
        ElementsActions.scrollDown();
        ElementsActions.click(createAccountButton);
    }

    @Step("Check if 'Create My Account' button is enabled")
    public boolean isCreateAccountButtonEnabled() {
        ElementsActions.hideKeyboard();
        ElementsActions.scrollDown();
        Waits.waitForElementToBeVisible(createAccountButton, Duration.ofSeconds(5));
        return ElementsActions.isEnabled(createAccountButton);
    }

    @Step("Check if on Registration screen")
    public boolean isRegisterScreenDisplayed() {
        return Waits.isElementVisible(firstNameField, Duration.ofSeconds(15))
                && Waits.isElementVisible(createAccountButton, Duration.ofSeconds(5));
    }

    // ==========================================
    // Registration Success Verification
    // ==========================================

    @Step("Wait for 'Account Created Successfully!' screen (up to {timeoutSeconds}s)")
    public boolean waitForSuccessScreen(int timeoutSeconds) {
        By descContainsTitle = AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"Account Created Successfully!\")");
        By textContainsTitle = AppiumBy.androidUIAutomator("new UiSelector().textContains(\"Account Created Successfully!\")");

        return Waits.isElementVisible(successTitle, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(goToHomeButton, Duration.ofSeconds(3))
                || Waits.isElementVisible(descContainsTitle, Duration.ofSeconds(3))
                || Waits.isElementVisible(textContainsTitle, Duration.ofSeconds(3));
    }

    @Step("Check if Success Screen is displayed")
    public boolean isSuccessScreenDisplayed() {
        return waitForSuccessScreen(30);
    }

    @Step("Tap 'Go to Home' button")
    public void tapGoToHome() {
        ElementsActions.click(goToHomeButton);
    }

    @Step("Check if Error message is displayed: '{expectedMessage}'")
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
