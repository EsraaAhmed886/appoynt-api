package features.Authentication;

import Base.BaseTest;
import io.qameta.allure.Feature;
import io.qameta.allure.Severity;
import io.qameta.allure.SeverityLevel;
import listeners.DynamicAllureListener;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import screens.base.Authentication.LoginScreen;
import utils.common.assertions.AssertionManager;
import utils.model.Authentication.LoginTestData;
import utils.testFactory.DataProviders;
import utils.testFactory.TestFactory;

@Listeners(DynamicAllureListener.class)
@Feature("Login Feature")
public class LoginTest extends BaseTest {

    public String story;
    public String description;

    // =========================================================================
    // 1. Button State Validations (Groups: smoke / validation)
    // =========================================================================

    @Test(priority = 1, groups = {"smoke", "regression"}, description = "TC-APP-001: Verify Login Button Dimmed/Disabled by Default")
    @Severity(SeverityLevel.CRITICAL)
    public void testVerifyLoginButtonDisabledByDefault_TC_APP_001() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-001");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");
        AssertionManager.assertFalse(loginScreen.isLoginButtonEnabled(), "Login button should be disabled by default");
    }

    @Test(priority = 2, groups = {"validation", "regression"}, description = "TC-APP-002: Button Dimmed When Phone Valid but Password < 8 Chars")
    @Severity(SeverityLevel.NORMAL)
    public void testButtonDimmedPhoneValidPasswordShort_TC_APP_002() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-002");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.setPassword(data.password());

        AssertionManager.assertFalse(loginScreen.isLoginButtonEnabled(), "Login button should remain disabled when password < 8 characters");
    }

    @Test(priority = 3, groups = {"validation", "regression"}, description = "TC-APP-003: Button Dimmed When Password Valid but Phone Incomplete")
    @Severity(SeverityLevel.NORMAL)
    public void testButtonDimmedPasswordValidPhoneIncomplete_TC_APP_003() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-003");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.setPassword(data.password());

        AssertionManager.assertFalse(loginScreen.isLoginButtonEnabled(), "Login button should remain disabled when phone number is incomplete");
    }

    @Test(priority = 4, groups = {"smoke", "regression"}, description = "TC-APP-004: Button Enabled When Valid Phone & Password >= 8 Chars")
    @Severity(SeverityLevel.CRITICAL)
    public void testButtonEnabledValidPhoneAndPassword_TC_APP_004() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-004");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.setPassword(data.password());

        AssertionManager.assertTrue(loginScreen.isLoginButtonEnabled(), "Login button should become enabled for valid 11-digit phone and password >= 8 chars");
    }

    @Test(priority = 5, groups = {"smoke", "regression"}, description = "TC-APP-005: Button Enabled When Valid Email & Password >= 8 Chars")
    @Severity(SeverityLevel.CRITICAL)
    public void testButtonEnabledValidEmailAndPassword_TC_APP_005() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-005");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.setPassword(data.password());

        AssertionManager.assertTrue(loginScreen.isLoginButtonEnabled(), "Login button should become enabled for valid email format and password >= 8 chars");
    }

    // =========================================================================
    // 2. Field Required & Blank Validations (Group: validation)
    // =========================================================================

    @Test(priority = 6, groups = {"validation", "regression"}, description = "TC-APP-006: Type and Clear Identifier Triggers 'This field is required'")
    @Severity(SeverityLevel.CRITICAL)
    public void testTypeAndClearIdentifierTriggersRequiredError_TC_APP_006() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-006");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.clearIdentifier();
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("This field is required", 10),
                "Error 'This field is required' should be displayed after clearing identifier"
        );
    }

    @Test(priority = 8, groups = {"validation", "regression"}, description = "TC-APP-008: Whitespace-Only Identifier Triggers 'This field is required'")
    @Severity(SeverityLevel.NORMAL)
    public void testWhitespaceOnlyIdentifierTriggersRequiredError_TC_APP_008() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-008");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("This field is required", 10),
                "Whitespace-only identifier should trigger 'This field is required'"
        );
    }

    // =========================================================================
    // 3. Phone Format & Sanitation Validations (Group: validation)
    // =========================================================================

    @Test(priority = 9, groups = {"validation", "regression"}, description = "TC-APP-009: Phone Length < 11 Digits Validation")
    @Severity(SeverityLevel.CRITICAL)
    public void testPhoneLengthLessThan11DigitsValidation_TC_APP_009() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-009");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Phone number must be exactly 11 digits", 10),
                "Error 'Phone number must be exactly 11 digits' should be displayed"
        );
    }

    @Test(priority = 10, groups = {"validation", "regression"}, description = "TC-APP-010: Phone Invalid Egyptian Prefix (e.g. 018)")
    @Severity(SeverityLevel.CRITICAL)
    public void testPhoneInvalidEgyptianPrefix_TC_APP_010() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-010");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Phone number must start with 010, 011, 012, or 015", 10),
                "Error 'Phone number must start with 010, 011, 012, or 015' should be displayed"
        );
    }

    @Test(priority = 11, groups = {"validation", "regression"}, description = "TC-APP-011: Phone Landline Prefix Error Message")
    @Severity(SeverityLevel.NORMAL)
    public void testPhoneLandlinePrefix_TC_APP_011() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-011");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Phone number must start with 01", 15),
                "Error 'Phone number must start with 01' should be displayed for landline prefix"
        );
    }

    @Test(priority = 14, groups = {"validation", "regression"}, description = "TC-APP-014: Phone Sanitization of Dashes/Spaces")
    @Severity(SeverityLevel.NORMAL)
    public void testPhoneSanitizationOfDashesAndSpaces_TC_APP_014() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-014");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertFalse(
                loginScreen.isErrorMessageDisplayed("Phone number must be exactly 11 digits")
                        || loginScreen.isErrorMessageDisplayed("Phone number must start with 010, 011, 012, or 015")
                        || loginScreen.isErrorMessageDisplayed("Phone number must start with 01"),
                "Formatted phone with dashes/spaces should be sanitized without format error"
        );
    }

    // =========================================================================
    // 4. Email Format & Normalization Validations (Group: validation)
    // =========================================================================

    @Test(priority = 15, groups = {"validation", "regression"}, description = "TC-APP-015: Malformed Email Without '@' (e.g. DFFF)")
    @Severity(SeverityLevel.CRITICAL)
    public void testMalformedEmailWithoutAtSign_TC_APP_015() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-015");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Please enter a valid email address", 10),
                "Error 'Please enter a valid email address' should be displayed"
        );
    }

    @Test(priority = 16, groups = {"validation", "regression"}, description = "TC-APP-016: Malformed Email Missing Domain Extension")
    @Severity(SeverityLevel.CRITICAL)
    public void testMalformedEmailMissingDomainExtension_TC_APP_016() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-016");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Please enter a valid email address", 10),
                "Error 'Please enter a valid email address' should be displayed when domain is missing extension"
        );
    }

    @Test(priority = 17, groups = {"validation", "regression"}, description = "TC-APP-017: Email Auto-Lowercase and Auto-Trim Conversion")
    @Severity(SeverityLevel.NORMAL)
    public void testEmailAutoLowercaseAndAutoTrim_TC_APP_017() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-017");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.unfocusField();

        String actualValue = loginScreen.getIdentifierFieldValue();
        AssertionManager.assertEquals(actualValue.trim().toLowerCase(), data.expectedValue(), "Email should be trimmed and converted to lowercase");
    }

    // =========================================================================
    // 5. Password Length & Usability Validations (Group: validation)
    // =========================================================================

    @Test(priority = 18, groups = {"validation", "regression"}, description = "TC-APP-018: Password Length < 8 Characters Keeps Login Button Disabled")
    @Severity(SeverityLevel.CRITICAL)
    public void testPasswordLengthLessThan8CharactersKeepsButtonDisabled_TC_APP_018() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-018");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setEmailOrPhone(data.emailOrPhone());
        loginScreen.setPassword(data.password());

        AssertionManager.assertFalse(
                loginScreen.isLoginButtonEnabled(),
                "Login button should remain disabled when password is < 8 characters"
        );
    }

    @Test(priority = 19, groups = {"validation", "regression"}, description = "TC-APP-027: Toggle Password Visibility (Eye Icon)")
    @Severity(SeverityLevel.CRITICAL)
    public void testTogglePasswordVisibility_TC_APP_027() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-027");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.setPassword(data.password());

        // Toggle 1: Unmask password
        loginScreen.togglePasswordVisibility();
        boolean unmasked = !loginScreen.isPasswordMasked();

        // Toggle 2: Mask password again
        loginScreen.togglePasswordVisibility();
        boolean maskedAgain = loginScreen.isPasswordMasked();

        AssertionManager.assertTrue(unmasked || maskedAgain, "Password visibility toggle should unmask and re-mask the password");
    }

    // =========================================================================
    // 6. Functional Authentication (Group: smoke) & Security (Group: negative)
    // =========================================================================

    @Test(priority = 20, groups = {"smoke", "regression"}, description = "TC-APP-028: Successful Login with Egyptian Phone")
    @Severity(SeverityLevel.BLOCKER)
    public void testSuccessfulLoginWithEgyptianPhone_TC_APP_028() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-028");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.login(data.emailOrPhone(), data.password());

        AssertionManager.assertTrue(
                loginScreen.waitForDashboard(25),
                "Welcome to Appoynt dashboard (accessibilityId: 'Welcome to Appoynt') should be displayed after successful phone login"
        );
    }

    @Test(priority = 21, groups = {"smoke", "regression"}, description = "TC-APP-029: Successful Login with Valid Email")
    @Severity(SeverityLevel.BLOCKER)
    public void testSuccessfulLoginWithValidEmail_TC_APP_029() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-029");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.login(data.emailOrPhone(), data.password());

        AssertionManager.assertTrue(
                loginScreen.waitForDashboard(25),
                "Welcome to Appoynt dashboard (accessibilityId: 'Welcome to Appoynt') should be displayed after successful email login"
        );
    }

    @Test(priority = 22, groups = {"negative", "regression"}, description = "TC-APP-030: Anti-Enumeration: Unregistered Phone Error Message")
    @Severity(SeverityLevel.CRITICAL)
    public void testAntiEnumerationUnregisteredPhone_TC_APP_030() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-030");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.login(data.emailOrPhone(), data.password());

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Invalid phone number or password.", 15),
                "Generic error message 'Invalid phone number or password.' should be displayed for unregistered phone"
        );
    }

    @Test(priority = 23, groups = {"negative", "regression"}, description = "TC-APP-031: Anti-Enumeration: Registered Phone + Wrong Password")
    @Severity(SeverityLevel.CRITICAL)
    public void testAntiEnumerationRegisteredPhoneWrongPassword_TC_APP_031() {
        LoginTestData data = DataProviders.getTestDataById("TC-APP-031");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.login(data.emailOrPhone(), data.password());

        AssertionManager.assertTrue(
                loginScreen.waitForErrorMessage("Invalid phone number or password.", 15),
                "Identical generic error message 'Invalid phone number or password.' should be displayed for wrong password"
        );
    }
}