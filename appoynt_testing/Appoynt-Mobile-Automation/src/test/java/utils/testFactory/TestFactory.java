package utils.testFactory;


import screens.android.Authentication.LoginAndroidScreen;
import screens.base.Authentication.LoginScreen;

public class TestFactory {


        public static LoginScreen getLoginScreen() {
            return new LoginAndroidScreen();
        }

        public static screens.base.Authentication.ForgetPasswordScreen getForgetPasswordScreen() {
            return new screens.android.Authentication.ForgetPasswordAndroidScreen();
        }

        public static screens.base.Authentication.OtpScreen getOtpScreen() {
            return new screens.android.Authentication.OtpAndroidScreen();
        }

        public static screens.base.Authentication.RegisterScreen getRegisterScreen() {
            return new screens.android.Authentication.RegisterAndroidScreen();
        }
    }


