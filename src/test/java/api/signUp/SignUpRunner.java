package api.signUp;

import com.intuit.karate.junit5.Karate;

public class SignUpRunner {

    @Karate.Test
    Karate signUp() {
        return Karate.run().relativeTo(getClass());
    }

}
