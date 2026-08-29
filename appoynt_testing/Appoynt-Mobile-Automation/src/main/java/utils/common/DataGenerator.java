package utils.common;

import java.util.Random;

public class DataGenerator {

    private static final Random random = new Random();
    private static final String[] EGYPTIAN_PREFIXES = {"010", "011", "012", "015"};

    /**
     * Generates a unique valid 11-digit Egyptian phone number.
     * Starts with 010, 011, 012, or 015 followed by 8 random digits.
     */
    public static String generateValidEgyptianPhone() {
        String prefix = EGYPTIAN_PREFIXES[random.nextInt(EGYPTIAN_PREFIXES.length)];
        long random8Digits = 10000000L + (long) (random.nextDouble() * 89999999L);
        return prefix + random8Digits;
    }

    /**
     * Generates a unique random email with current timestamp.
     */
    public static String generateRandomEmail() {
        return "auto_" + System.currentTimeMillis() + "_" + (100 + random.nextInt(900)) + "@gmail.com";
    }

    /**
     * Generates a random First Name.
     */
    public static String generateRandomFirstName() {
        return "AutoUser" + (100 + random.nextInt(900));
    }

    /**
     * Generates a random Last Name.
     */
    public static String generateRandomLastName() {
        return "Test" + (100 + random.nextInt(900));
    }

    /**
     * Resolves phone input: If value is "RANDOM" or "DYNAMIC" or empty, returns a newly generated valid phone.
     * Otherwise returns the original phone string (preserving invalid formatting for negative test cases).
     */
    public static String resolvePhone(String inputPhone) {
        if (inputPhone == null || inputPhone.isBlank()
                || "DYNAMIC".equalsIgnoreCase(inputPhone)
                || "RANDOM".equalsIgnoreCase(inputPhone)) {
            return generateValidEgyptianPhone();
        }
        return inputPhone;
    }

    /**
     * Resolves email input: If value is "RANDOM" or "DYNAMIC" or empty, returns a newly generated random email.
     * Otherwise returns the original email string (preserving invalid formatting for negative test cases).
     */
    public static String resolveEmail(String inputEmail) {
        if (inputEmail == null || inputEmail.isBlank()
                || "DYNAMIC".equalsIgnoreCase(inputEmail)
                || "RANDOM".equalsIgnoreCase(inputEmail)) {
            return generateRandomEmail();
        }
        return inputEmail;
    }
}
