@ignore
Feature: Helper - log in to DummyJSON and return the tokens

  Scenario: Obtain access and refresh tokens
    Given url authBaseUrl
    And path 'auth', 'login'
    And request { username: '#(username)', password: '#(password)', expiresInMins: '#(expiresInMins)' }
    When method post
    Then status 200
    * def accessToken = response.accessToken
    * def refreshToken = response.refreshToken
    * def userId = response.id
