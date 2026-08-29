package screens.base.Authentication;

import io.appium.java_client.AppiumBy;
import io.qameta.allure.Step;
import org.openqa.selenium.By;
import utils.appium.ElementsActions;
import utils.appium.Waits;

import java.time.Duration;

public abstract class LoginScreen {

    // Core interactive elements
    protected static final By emailOrPhoneField =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.EditText\").instance(0)"
            );

    protected static final By passwordField =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.EditText\").instance(1)"
            );

    protected static final By loginButton =
            AppiumBy.accessibilityId("Login");

    protected static final By welcomeHeader =
            AppiumBy.accessibilityId("Welcome to Appoynt");

    protected static final By forgotPasswordLink =
            AppiumBy.accessibilityId("Forgot Password?");

    protected static final By signUpLink =
            AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"Sign Up\")");

    protected static final By passwordEyeToggle =
            AppiumBy.androidUIAutomator(
                    "new UiSelector().className(\"android.widget.ImageView\").instance(0)"
            );


    @Step("Enter email or phone: {emailOrPhone}")
    public void setEmailOrPhone(String emailOrPhone) {
        ElementsActions.setValue(
                emailOrPhoneField,
                emailOrPhone
        );
    }


    @Step("Enter password")
    public void setPassword(String password) {
        ElementsActions.setValue(
                passwordField,
                password
        );
    }


    @Step("Clear Identifier (email/phone) field")
    public void clearIdentifier() {
        ElementsActions.clear(emailOrPhoneField);
    }


    @Step("Clear Password field")
    public void clearPassword() {
        ElementsActions.clear(passwordField);
    }


    @Step("Get value of Identifier (email/phone) field")
    public String getIdentifierFieldValue() {
        return ElementsActions.getValue(emailOrPhoneField);
    }


    @Step("Get value of Password field")
    public String getPasswordFieldValue() {
        return ElementsActions.getValue(passwordField);
    }


    @Step("Unfocus field / tap outside")
    public void unfocusField() {
        ElementsActions.hideKeyboard();
    }


    @Step("Verify Login screen is displayed")
    public boolean isInLoginScreen() {
        return ElementsActions.isDisplayed(emailOrPhoneField)
                && ElementsActions.isDisplayed(passwordField)
                && ElementsActions.isDisplayed(loginButton);
    }


    @Step("Check if Login button is enabled")
    public boolean isLoginButtonEnabled() {
        unfocusField();
        return ElementsActions.isEnabled(loginButton);
    }


    @Step("Wait for Dashboard / Welcome header to appear")
    public boolean waitForDashboard(int timeoutSeconds) {
        By welcomeAccId = AppiumBy.accessibilityId("Welcome to Appoynt");
        By welcomeDescContains = AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"Welcome\")");
        By welcomeTextContains = AppiumBy.androidUIAutomator("new UiSelector().textContains(\"Welcome\")");

        return Waits.isElementVisible(welcomeAccId, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(welcomeDescContains, Duration.ofSeconds(3))
                || Waits.isElementVisible(welcomeTextContains, Duration.ofSeconds(3));
    }


    @Step("Check if Welcome header is displayed")
    public boolean isWelcomeHeaderDisplayed() {
        return waitForDashboard(15);
    }


    @Step("Check if Error message is displayed: '{expectedMessage}'")
    public boolean isErrorMessageDisplayed(String expectedMessage) {
        return waitForErrorMessage(expectedMessage, 10);
    }


    @Step("Wait for Error message to appear: '{expectedMessage}'")
    public boolean waitForErrorMessage(String expectedMessage, int timeoutSeconds) {
        By errorLocator = AppiumBy.accessibilityId(expectedMessage);
        String textClean = expectedMessage.replace(".", "").replace("'", "");
        By descContains = AppiumBy.androidUIAutomator("new UiSelector().descriptionContains(\"" + textClean + "\")");
        By textContains = AppiumBy.androidUIAutomator("new UiSelector().textContains(\"" + textClean + "\")");

        return Waits.isElementVisible(errorLocator, Duration.ofSeconds(timeoutSeconds))
                || Waits.isElementVisible(descContains, Duration.ofSeconds(3))
                || Waits.isElementVisible(textContains, Duration.ofSeconds(3));
    }


    @Step("Toggle Password Visibility (Eye Icon)")
    public void togglePasswordVisibility() {
        ElementsActions.click(passwordEyeToggle);
    }


    @Step("Check if Password is masked")
    public boolean isPasswordMasked() {
        String passwordAttr = ElementsActions.getAttribute(passwordField, "password");
        if (passwordAttr != null && !passwordAttr.isEmpty()) {
            return Boolean.parseBoolean(passwordAttr);
        }
        String text = ElementsActions.getText(passwordField);
        return text.contains("•") || text.contains("●");
    }


    @Step("Tap 'Forgot Password' link")
    public void tapForgotPassword() {
        ElementsActions.click(forgotPasswordLink);
    }


    @Step("Tap 'Sign Up' link")
    public void tapSignUp() {
        ElementsActions.click(signUpLink);
    }


    @Step("Check if navigated to Forgot Password screen")
    public boolean isInForgotPasswordScreen() {
        return Waits.isElementVisible(AppiumBy.accessibilityId("Forgot Password"), Duration.ofSeconds(10))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Reset Password"), Duration.ofSeconds(5))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Forgot Password?"), Duration.ofSeconds(5));
    }


    @Step("Check if navigated to Sign Up screen")
    public boolean isInSignUpScreen() {
        return Waits.isElementVisible(AppiumBy.accessibilityId("Sign Up"), Duration.ofSeconds(10))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Create Account"), Duration.ofSeconds(5))
                || Waits.isElementVisible(AppiumBy.accessibilityId("Register"), Duration.ofSeconds(5));
    }


    @Step("Login with credentials: {emailOrPhone}")
    public void login(String emailOrPhone, String password) {
        setEmailOrPhone(emailOrPhone);
        setPassword(password);
        unfocusField();
        tapLoginButton();
    }


    public abstract void tapLoginButton();
}

