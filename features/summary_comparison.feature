Feature: Summary comparison
  
  Scenario: No change in speed or variability

    User submits two data sets indicating no significant
    difference in response time or consistency

    Given two data sets
    When I request a comparison
    Then the stdout should contain "Average response time hasn't changed"
    And the stdout should contain "Variability in response times hasn't changed"