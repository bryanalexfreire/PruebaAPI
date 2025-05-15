package helpers;

import com.github.javafaker.Faker;

public class DataGenerator {

    public static String getRandomUsername() {
        Faker faker = new Faker();
        String randomUsername = faker.name().username().toLowerCase() + faker.number().digits(6);
        return randomUsername;

    }

    public static String getRandomPassword() {
        Faker faker = new Faker();
        String randomPassword = faker.internet().password(8, 12, true, true);
        return randomPassword;
    }
}
