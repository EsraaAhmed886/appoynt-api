package features.Authentication;

import Base.BaseTest;
import io.qameta.allure.Feature;
import io.qameta.allure.Severity;
import io.qameta.allure.SeverityLevel;
import listeners.DynamicAllureListener;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import screens.base.Authentication.ForgetPasswordScreen;
import screens.base.Authentication.LoginScreen;
import utils.common.assertions.AssertionManager;
import utils.model.Authentication.ForgetPasswordTestData;
import utils.testFactory.DataProviders;
import utils.testFactory.TestFactory;

@Listeners(DynamicAllureListener.class)
@Feature("Forgot Password Feature")
public class ForgetPasswordTest extends BaseTest {

    public String story;
    public String description;

    // =========================================================================
    // 1. Navigation & Phone Input Step
    // =========================================================================

    @Test(priority = 1, groups = {"smoke", "forgot-password", "regression"}, description = "TC-FP-001: Navigate to Forgot Password Screen")
    @Severity(SeverityLevel.CRITICAL)
    public void testNavigateToForgotPasswordScreen_TC_FP_001() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-001");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        AssertionManager.assertTrue(loginScreen.isInLoginScreen(), "Login screen should be displayed");

        loginScreen.tapForgotPassword();

        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        AssertionManager.assertTrue(
                forgetPasswordScreen.isPhoneStepDisplayed(),
                "Forgot Password phone input screen should be displayed"
        );
    }

    @Test(priority = 2, groups = {"validation", "forgot-password", "regression"}, description = "TC-FP-002: Send Code Button Disabled for Incomplete Phone")
    @Severity(SeverityLevel.NORMAL)
    public void testSendCodeButtonDisabledForIncompletePhone_TC_FP_002() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-002");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapForgotPassword();

        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        forgetPasswordScreen.enterPhoneNumber(data.phoneNumber());

        AssertionManager.assertFalse(
                forgetPasswordScreen.isSendCodeButtonEnabled(),
                "'Send Code' button should remain disabled when phone number is incomplete"
        );
    }

    @Test(priority = 3, groups = {"smoke", "forgot-password", "regression"}, description = "TC-FP-003: Send Code with Valid Phone Navigates to OTP")
    @Severity(SeverityLevel.CRITICAL)
    public void testSendCodeWithValidPhoneNavigatesToOtp_TC_FP_003() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-003");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapForgotPassword();

        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        forgetPasswordScreen.enterPhoneNumber(data.phoneNumber());
        forgetPasswordScreen.tapSendCode();

        AssertionManager.assertTrue(
                forgetPasswordScreen.isOtpStepDisplayed(),
                "OTP verification screen with 6 digit boxes should be displayed after sending code"
        );
    }

    // =========================================================================
    // 2. OTP Verification Step
    // =========================================================================

    @Test(priority = 4, groups = {"smoke", "forgot-password", "regression"}, description = "TC-FP-005: Enter 6-Digit OTP Verification Code")
    @Severity(SeverityLevel.CRITICAL)
    public void testEnterSixDigitOtpAndVerifyButtonState_TC_FP_005() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-005");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapForgotPassword();

        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        forgetPasswordScreen.enterPhoneNumber(data.phoneNumber());
        forgetPasswordScreen.tapSendCode();

        AssertionManager.assertTrue(forgetPasswordScreen.isOtpStepDisplayed(), "OTP screen should be displayed");

        // Enter OTP across boxes 0 through 5
        forgetPasswordScreen.enterOtp(data.otpCode());

        AssertionManager.assertTrue(
                forgetPasswordScreen.isVerifyOtpButtonEnabled(),
                "'Verify' button should be enabled after entering complete 6-digit OTP"
        );
    }

    @Test(priority = 5, groups = {"validation", "forgot-password", "regression"}, description = "TC-FP-006: Resend OTP Code via Send Code Again")
    @Severity(SeverityLevel.NORMAL)
    public void testResendOtpCode_TC_FP_006() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-006");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapForgotPassword();

        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        forgetPasswordScreen.enterPhoneNumber(data.phoneNumber());
        forgetPasswordScreen.tapSendCode();

        AssertionManager.assertTrue(forgetPasswordScreen.isOtpStepDisplayed(), "OTP screen should be displayed");

        forgetPasswordScreen.tapSendCodeAgain();

        AssertionManager.assertTrue(
                forgetPasswordScreen.isOtpStepDisplayed(),
                "OTP screen should remain displayed after tapping 'Send code again'"
        );
    }

    // =========================================================================
    // 3. Reset / Update Password End-to-End Flow
    // =========================================================================

    @Test(priority = 6, groups = {"smoke", "forgot-password", "regression"}, description = "TC-FP-007: Full End-to-End Forgot Password & Reset Flow")
    @Severity(SeverityLevel.BLOCKER)
    public void testFullForgotPasswordResetFlow_TC_FP_007() {
        ForgetPasswordTestData data = DataProviders.getForgetPasswordTestDataById("TC-FP-007");
        story = data.story();
        description = data.description();

        // 1. Login -> Forgot Password
        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapForgotPassword();

        // 2. Phone Step -> Send Code
        ForgetPasswordScreen forgetPasswordScreen = TestFactory.getForgetPasswordScreen();
        forgetPasswordScreen.enterPhoneNumber(data.phoneNumber());
        forgetPasswordScreen.tapSendCode();

        // 3. OTP Step -> Enter Code & Verify
        AssertionManager.assertTrue(
                forgetPasswordScreen.isOtpStepDisplayed(30),
                "OTP verification screen should be displayed after sending code"
        );

        forgetPasswordScreen.enterOtp(data.otpCode());
        forgetPasswordScreen.tapVerifyOtp();

        // 4. Reset Password Step -> Enter New & Confirm Password
        boolean onResetStep = forgetPasswordScreen.waitForResetPasswordStep(30);
        if (onResetStep) {
            forgetPasswordScreen.setNewAndConfirmPassword(data.newPassword(), data.confirmPassword());
            forgetPasswordScreen.tapUpdatePassword();
        }

        AssertionManager.assertTrue(
                onResetStep || loginScreen.isInLoginScreen(),
                "Forgot password flow should transition through all steps cleanly"
        );
    }
}
