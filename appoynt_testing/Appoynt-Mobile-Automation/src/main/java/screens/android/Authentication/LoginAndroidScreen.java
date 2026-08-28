package screens.android.Authentication;


import io.qameta.allure.Step;
import screens.base.Authentication.LoginScreen;
import utils.appium.ElementsActions;

public class LoginAndroidScreen extends LoginScreen {

    @Override
    @Step("Tap Login button")
    public void tapLoginButton() {
        unfocusField();
        ElementsActions.click(loginButton);
    }
}