package utils.model.Authentication;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record LoginTestData(
        @JsonProperty("testCaseId")
        String testCaseId,

        @JsonProperty("emailOrPhone")
        String emailOrPhone,

        @JsonProperty("password")
        String password,

        @JsonProperty("expectedErrorMessage")
        String expectedErrorMessage,

        @JsonProperty("expectedValue")
        String expectedValue,

        @JsonProperty("story")
        String story,

        @JsonProperty("description")
        String description
) {
}