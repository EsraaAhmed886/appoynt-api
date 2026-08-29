package utils.testFactory;

import org.testng.annotations.DataProvider;
import utils.common.JsonUtils;
import utils.model.Authentication.LoginTestData;

import java.util.Arrays;

public class DataProviders {

    private static final LoginTestData[] loginTestDataList =
            JsonUtils.readJson(
                    "src/test/resources/loginTestData.json",
                    LoginTestData[].class
            );

    public static LoginTestData getTestDataById(String testCaseId) {
        return Arrays.stream(loginTestDataList)
                .filter(data -> testCaseId.equalsIgnoreCase(data.testCaseId()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Test case ID not found in JSON: " + testCaseId));
    }

    @DataProvider(name = "allLoginTestData")
    public static Object[][] allLoginTestData() {
        Object[][] data = new Object[loginTestDataList.length][1];
        for (int i = 0; i < loginTestDataList.length; i++) {
            data[i][0] = loginTestDataList[i];
        }
        return data;
    }

    @DataProvider(name = "validLoginData")
    public static Object[][] validLoginData() {
        LoginTestData[] filtered = Arrays.stream(loginTestDataList)
                .filter(d -> "TC-APP-028".equals(d.testCaseId()) || "TC-APP-029".equals(d.testCaseId()))
                .toArray(LoginTestData[]::new);

        Object[][] data = new Object[filtered.length][1];
        for (int i = 0; i < filtered.length; i++) {
            data[i][0] = filtered[i];
        }
        return data;
    }

    private static final utils.model.Authentication.ForgetPasswordTestData[] forgetPasswordTestDataList =
            JsonUtils.readJson(
                    "src/test/resources/forgetPasswordTestData.json",
                    utils.model.Authentication.ForgetPasswordTestData[].class
            );

    public static utils.model.Authentication.ForgetPasswordTestData getForgetPasswordTestDataById(String testCaseId) {
        return Arrays.stream(forgetPasswordTestDataList)
                .filter(data -> testCaseId.equalsIgnoreCase(data.testCaseId()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Forget Password Test case ID not found in JSON: " + testCaseId));
    }

    private static final utils.model.Authentication.RegisterTestData[] registerTestDataList =
            JsonUtils.readJson(
                    "src/test/resources/registerTestData.json",
                    utils.model.Authentication.RegisterTestData[].class
            );

    public static utils.model.Authentication.RegisterTestData getRegisterTestDataById(String testCaseId) {
        return Arrays.stream(registerTestDataList)
                .filter(data -> testCaseId.equalsIgnoreCase(data.testCaseId()))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Register Test case ID not found in JSON: " + testCaseId));
    }
}