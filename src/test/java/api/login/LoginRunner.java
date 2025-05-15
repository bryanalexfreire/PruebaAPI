package api.login;

import com.intuit.karate.junit5.Karate;

public class LoginRunner {
    @Karate.Test
    Karate login() {
        return Karate.run().relativeTo(getClass());
    }
}
