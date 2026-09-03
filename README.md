# PruebaAPI ⭐
This project was generated with Karate, Cucumber and Gherkin.

1. Prerequisites: 📃
   - Local machine with Windows 101
   - IDE: IntelliJ IDEA 2023.33 Community Edition (must be installed)
   - Gradle 8.7 (must be installed and added to PATH)
   - Java SE - JDK 21 (must be installed and added to PATH)

2. Instructions for running the tests: ✔️
   - Open IntelliJ
   - Open the project
   - Select the project
   - Wait for dependencies to download (progress is shown in the status bar)

   **** RUN TESTS ****

   Evidence:

   - Open the file ManagmentTest.java
   - Right-click on the editor
   - Click on "Run ManagmentTest"

   **** VIEW REPORTS ****

   - In the project view open the "build" folder
   - Open the "Karate-reports" folder
   - Open "karate-summary.html" in a browser to view the Karate report

   - In the project view open the "build" folder
   - Open the "cucumber-html-reports" folder
   - Open "overview-features.html" in a browser to view the Cucumber report

3. Additional information: ➕
   - This repository contains 4 folders with evidence such as Postman collections, a conclusions file

4. CI/CD with GitHub Actions: 🚀
   - Workflow location: `.github/workflows/qa-ci.yml`
   - Triggered on:
     - Push to `main` and `develop`
     - Pull Requests to `main` and `develop`
     - Manual execution (`workflow_dispatch`)
   - Pipeline actions:
     - Checks out source code
     - Uses JDK 21 (Temurin) with Gradle dependency cache
     - Validates Gradle Wrapper integrity
     - Executes `./gradlew --no-daemon clean test`
     - Uploads QA artifacts (JUnit, Karate and Cucumber reports) for each run
   - Artifacts generated:
     - `build/test-results/test`
     - `build/reports/tests/test`
     - `build/karate-reports`
     - `build/cucumber-html-reports`

AUTHOR 📍
@BryanFreire
