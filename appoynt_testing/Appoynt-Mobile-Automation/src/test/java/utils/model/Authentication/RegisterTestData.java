package utils.model.Authentication;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public record RegisterTestData(
        String testCaseId,
        String firstName,
        String lastName,
        String email,
        String phone,
        String password,
        String confirmPassword,
        String otpCode,
        String expectedErrorMessage,
        String expectedSuccessMessage,
        String story,
        String description
) {
}
