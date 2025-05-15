Feature: Signup an user in website

  Background:
    # Data for testing API
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def urlBase = 'https://api.demoblaze.com/'
    * def path = 'signup'


    # Params to be used in scenarios
  @NewUser
  Scenario: Signup an user
    * def requestData = read('requestData.json')
    * def newUser = dataGenerator.getRandomUsername()
    * def newPassword = dataGenerator.getRandomPassword()
    And requestData.username = newUser
    And requestData.password = newPassword
    Given url urlBase + path
    And request requestData
    When method post
    Then status 200
    * print requestData
    * print response

    @OldUser
    Scenario Outline: Singup an existing user
      * def requestData = read('requestOldData.json')
      Given url urlBase + path
      And request requestData
      When method post
      Then status 200
      And match response =={ "errorMessage": "This user already exist." }
      * print response
      Examples:
      | read('classpath:../data.csv') |