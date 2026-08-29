package listeners;

import io.qameta.allure.Allure;
import io.qameta.allure.model.Label;
import org.testng.IInvokedMethod;
import org.testng.IInvokedMethodListener;
import org.testng.ITestResult;
import utils.common.LogsUtils;
import utils.common.PropertiesUtils;

import java.lang.reflect.Field;
import java.util.UUID;

public class DynamicAllureListener implements IInvokedMethodListener {

    @Override
    public void afterInvocation(IInvokedMethod method, ITestResult testResult) {
        if (!method.isTestMethod()) {
            return;
        }

        Object testInstance = testResult.getInstance();
        if (testInstance == null) {
            return;
        }

        try {
            Field storyField = testInstance.getClass().getField("story");
            Field descriptionField = testInstance.getClass().getField("description");

            String story = (String) storyField.get(testInstance);
            String description = (String) descriptionField.get(testInstance);

            Allure.getLifecycle().getCurrentTestCase().ifPresent(uuid -> {
                if (story != null && !story.isBlank()) {
                    Allure.getLifecycle().updateTestCase(uuid, tc ->
                            tc.getLabels().add(new Label().setName("story").setValue(story))
                    );
                }
                if (description != null && !description.isBlank()) {
                    Allure.getLifecycle().updateTestCase(uuid, tc ->
                            tc.setDescription(description)
                    );
                }
                if (story != null || description != null) {
                    String platform = PropertiesUtils.getProperty("platformName", "Android");
                    String raw = platform + (story != null ? story : "") + (description != null ? description : "");
                    Allure.getLifecycle().updateTestCase(uuid, tc ->
                            tc.setHistoryId(UUID.nameUUIDFromBytes(raw.getBytes()).toString())
                    );
                }
            });
        } catch (NoSuchFieldException ignored) {
            // Fields are not defined on this test class
        } catch (Exception e) {
            LogsUtils.error("Failed to set story or description: " + e.getMessage());
        } finally {
            utils.common.assertions.AssertionManager.assertAll(testResult);
        }
    }
}
