@jwt
Feature: JWT authentication (DummyJSON auth API)

  Token-based authentication against the public DummyJSON API
  (https://dummyjson.com/docs/auth): login, JWT header and claims,
  protected endpoint, refresh flow, and rejection of missing, malformed,
  tampered and unsigned tokens. The credentials are the public demo user
  published in the DummyJSON docs.

  Background:
    * def authBaseUrl = 'https://dummyjson.com'
    * def credentials = { username: 'emilys', password: 'emilyspass', expiresInMins: 30 }
    * def loginArgs = karate.merge(credentials, { authBaseUrl: authBaseUrl })
    * def session = callonce read('get-token.feature') loginArgs
    * url authBaseUrl
    # Base64URL helpers to read and forge JWT segments
    * def decodePart =
      """
      function(part) {
        var Base64 = Java.type('java.util.Base64');
        var JString = Java.type('java.lang.String');
        var text = new JString(Base64.getUrlDecoder().decode(part), 'UTF-8');
        return JSON.parse('' + text);
      }
      """
    * def encodePart =
      """
      function(text) {
        var Base64 = Java.type('java.util.Base64');
        var JString = Java.type('java.lang.String');
        return Base64.getUrlEncoder().withoutPadding().encodeToString(new JString(text).getBytes('UTF-8'));
      }
      """

  @smoke
  Scenario: Login with valid credentials returns an access token and a refresh token
    Given path 'auth', 'login'
    And request credentials
    When method post
    Then status 200
    And match response contains { id: '#number', username: 'emilys', accessToken: '#string', refreshToken: '#string' }
    And match response.accessToken == '#regex [A-Za-z0-9_-]+[.][A-Za-z0-9_-]+[.][A-Za-z0-9_-]+'

  Scenario: Access token header and claims match the user and the requested lifetime
    * def parts = session.accessToken.split('.')
    * def tokenHeader = decodePart(parts[0])
    * def claims = decodePart(parts[1])
    * match tokenHeader contains { typ: 'JWT', alg: '#string' }
    * match tokenHeader.alg != 'none'
    * match claims contains { id: '#(session.userId)', username: 'emilys', iat: '#number', exp: '#number' }
    * assert claims.exp - claims.iat == credentials.expiresInMins * 60

  Scenario: Protected endpoint returns the profile of the token owner
    Given path 'auth', 'me'
    And header Authorization = 'Bearer ' + session.accessToken
    When method get
    Then status 200
    And match response contains { id: '#(session.userId)', username: 'emilys', email: '#regex .+@.+' }

  Scenario: Refresh token issues a new access token that the API accepts
    Given path 'auth', 'refresh'
    And request { refreshToken: '#(session.refreshToken)', expiresInMins: 30 }
    When method post
    Then status 200
    And match response contains { accessToken: '#string', refreshToken: '#string' }
    * def newAccessToken = response.accessToken

    Given path 'auth', 'me'
    And header Authorization = 'Bearer ' + newAccessToken
    When method get
    Then status 200
    And match response.username == 'emilys'

  Scenario: Protected endpoint rejects a request without a token
    Given path 'auth', 'me'
    When method get
    Then status 401
    And match response contains { message: '#string' }

  Scenario: Protected endpoint rejects a malformed token
    Given path 'auth', 'me'
    And header Authorization = 'Bearer not-a-jwt'
    When method get
    Then status 401
    And match response contains { message: '#string' }

  Scenario: Protected endpoint rejects a token whose payload was changed
    * def parts = session.accessToken.split('.')
    * def claims = decodePart(parts[1])
    * set claims.id = 2
    * set claims.username = 'michaelw'
    * string forgedPayload = claims
    * def forgedToken = parts[0] + '.' + encodePart(forgedPayload) + '.' + parts[2]
    Given path 'auth', 'me'
    And header Authorization = 'Bearer ' + forgedToken
    When method get
    Then status 401
    And match response contains { message: '#string' }

  Scenario: Protected endpoint rejects an unsigned token (alg none)
    * def parts = session.accessToken.split('.')
    * string noneHeader = { alg: 'none', typ: 'JWT' }
    * def unsignedToken = encodePart(noneHeader) + '.' + parts[1] + '.'
    Given path 'auth', 'me'
    And header Authorization = 'Bearer ' + unsignedToken
    When method get
    Then status 401
    And match response contains { message: '#string' }

  Scenario: Refresh endpoint rejects an invalid refresh token
    Given path 'auth', 'refresh'
    And request { refreshToken: 'invalid.refresh.token' }
    When method post
    Then match [401, 403] contains responseStatus
    And match response contains { message: '#string' }

  Scenario Outline: Login is rejected with <case>
    Given path 'auth', 'login'
    And request <body>
    When method post
    Then status 400
    And match response contains { message: '#string' }

    Examples:
      | case             | body                                                 |
      | a wrong password | { username: 'emilys', password: 'wrong-password' }   |
      | an unknown user  | { username: 'unknown-qa-user', password: 'any-pass' } |
      | missing fields   | {}                                                   |
