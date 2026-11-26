# Karate API tests

API test suite built with Karate, Cucumber and JUnit 5 on Gradle. It covers two public APIs:

- **Demoblaze** (`https://api.demoblaze.com`): login and sign-up endpoints with positive and negative scenarios.
- **DummyJSON auth** (`https://dummyjson.com/auth`): JWT authentication, from login to protected endpoints and token refresh.

## What it demonstrates

- API tests written as readable Gherkin with Karate, no glue code.
- Positive and negative coverage: valid user, wrong user, wrong password, missing fields, empty body, new user and duplicated user.
- JWT authentication tests: token format, header and claims (user id, username, `exp - iat` matching the requested lifetime), Bearer access to a protected endpoint, refresh flow, and rejection of missing, malformed, tampered-payload and unsigned (`alg: none`) tokens.
- Login done once per feature with `callonce` and reused across scenarios.
- Random test data generated with a Java helper (`DataGenerator`) so sign-up runs are repeatable.
- Cucumber and Karate HTML reports generated on every run.
- CI on GitHub Actions: Gradle wrapper validation, test run and report artifacts.
- Postman collections of the same endpoints for manual exploration (`postman/`).

## Project structure

```
src/test/java/api/login/    login scenarios
src/test/java/api/signUp/   sign-up scenarios
src/test/java/api/auth/     JWT authentication scenarios (DummyJSON)
src/test/java/helpers/      test data generator
postman/                    Postman collections
docs/conclusions.md         notes on the framework
.github/workflows/qa-ci.yml CI pipeline
```

## Requirements

- JDK 21
- Gradle wrapper included (no install needed)

## Run the tests

```bash
./gradlew clean test
```

The JWT suite is tagged `@jwt`. To run only that feature:

```bash
./gradlew clean test -Dkarate.options="--tags @jwt"
```

Reports are written to:

- `build/karate-reports/karate-summary.html`
- `build/cucumber-html-reports/overview-features.html`

## CI

`.github/workflows/qa-ci.yml` runs on every push and pull request to `main` and `develop`, and manually. It runs `./gradlew clean test` on JDK 21 (Temurin) and uploads the JUnit, Karate and Cucumber reports as artifacts.

## Author

Bryan Freire, QA Automation Engineer. [LinkedIn](https://www.linkedin.com/in/bryanalexanderfreire/)
