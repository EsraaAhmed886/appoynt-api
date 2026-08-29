package utils.model.Authentication;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record ForgetPasswordTestData(
        String testCaseId,
        String phoneNumber,
        String otpCode,
        String newPassword,
        String confirmPassword,
        String expectedErrorMessage,
        String expectedSuccessMessage,
        String story,
        String description
) {
}
