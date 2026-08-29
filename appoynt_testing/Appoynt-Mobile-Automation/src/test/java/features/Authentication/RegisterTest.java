package features.Authentication;

import Base.BaseTest;
import io.qameta.allure.Feature;
import io.qameta.allure.Severity;
import io.qameta.allure.SeverityLevel;
import listeners.DynamicAllureListener;
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;
import screens.base.Authentication.LoginScreen;
import screens.base.Authentication.OtpScreen;
import screens.base.Authentication.RegisterScreen;
import utils.common.DataGenerator;
import utils.common.assertions.AssertionManager;
import utils.model.Authentication.RegisterTestData;
import utils.testFactory.DataProviders;
import utils.testFactory.TestFactory;

@Listeners(DynamicAllureListener.class)
@Feature("User Registration Feature")
public class RegisterTest extends BaseTest {

    public String story;
    public String description;

    // =========================================================================
    // 1. Form Validation & Button State Tests
    // =========================================================================

    @Test(priority = 1, groups = {"validation", "register", "regression"}, description = "TC-REG-001: Create Account Button Disabled for Incomplete Form")
    @Severity(SeverityLevel.NORMAL)
    public void testCreateAccountButtonDisabledForIncompleteForm_TC_REG_001() {
        RegisterTestData data = DataProviders.getRegisterTestDataById("TC-REG-001");
        story = data.story();
        description = data.description();

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapSignUp();

        RegisterScreen registerScreen = TestFactory.getRegisterScreen();
        AssertionManager.assertTrue(registerScreen.isRegisterScreenDisplayed(), "Registration screen should be displayed");

        registerScreen.setFirstName(data.firstName());
        registerScreen.setLastName(data.lastName());

        AssertionManager.assertFalse(
                registerScreen.isCreateAccountButtonEnabled(),
                "'Create My Account' button should remain disabled when form is incomplete"
        );
    }

    @Test(priority = 2, groups = {"smoke", "register", "regression"}, description = "TC-REG-002: Create Account Button Enabled for Valid Form & Terms")
    @Severity(SeverityLevel.CRITICAL)
    public void testCreateAccountButtonEnabledForValidForm_TC_REG_002() {
        RegisterTestData data = DataProviders.getRegisterTestDataById("TC-REG-002");
        story = data.story();
        description = data.description();

        String email = DataGenerator.resolveEmail(data.email());
        String phone = DataGenerator.resolvePhone(data.phone());

        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapSignUp();

        RegisterScreen registerScreen = TestFactory.getRegisterScreen();
        AssertionManager.assertTrue(registerScreen.isRegisterScreenDisplayed(), "Registration screen should be displayed");

        registerScreen.fillRegistrationForm(
                data.firstName(),
                data.lastName(),
                email,
                phone,
                data.password(),
                data.confirmPassword()
        );
        registerScreen.acceptTerms();

        AssertionManager.assertTrue(
                registerScreen.isCreateAccountButtonEnabled(),
                "'Create My Account' button should become enabled when valid data is entered and terms accepted"
        );
    }

    // =========================================================================
    // 2. Full End-to-End Registration & OTP Flow
    // =========================================================================

    @Test(priority = 3, groups = {"smoke", "register", "regression"}, description = "TC-REG-003: Full End-to-End Registration & OTP Verification Flow")
    @Severity(SeverityLevel.BLOCKER)
    public void testFullRegistrationAndOtpVerificationFlow_TC_REG_003() {
        RegisterTestData data = DataProviders.getRegisterTestDataById("TC-REG-003");
        story = data.story();
        description = data.description();

        String email = DataGenerator.resolveEmail(data.email());
        String phone = DataGenerator.resolvePhone(data.phone());

        // 1. Navigate from Login to Sign Up
        LoginScreen loginScreen = TestFactory.getLoginScreen();
        loginScreen.tapSignUp();

        // 2. Fill Registration Form with dynamic email and Egyptian phone
        RegisterScreen registerScreen = TestFactory.getRegisterScreen();
        AssertionManager.assertTrue(registerScreen.isRegisterScreenDisplayed(), "Registration screen should be displayed");

        registerScreen.fillRegistrationForm(
                data.firstName(),
                data.lastName(),
                email,
                phone,
                data.password(),
                data.confirmPassword()
        );
        registerScreen.acceptTerms();

        // 3. Tap Create My Account
        registerScreen.tapCreateAccount();

        // 4. OTP Verification Step
        OtpScreen otpScreen = TestFactory.getOtpScreen();
        AssertionManager.assertTrue(
                otpScreen.isOtpScreenDisplayed(30),
                "OTP verification screen should be displayed after submitting registration"
        );

        otpScreen.enterOtp(data.otpCode());
        otpScreen.tapVerify();

        // 5. Success Screen Verification ("Account Created Successfully!")
        AssertionManager.assertTrue(
                registerScreen.waitForSuccessScreen(30),
                "Title 'Account Created Successfully!' should be displayed after successful registration & OTP verification"
        );
    }
}
