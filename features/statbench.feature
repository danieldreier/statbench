Feature: Summarize changes
  Scenario: User gives data files
    Given two data files
    When I request summary data
    Then I should be told which configuration is faster
    And I should be told which configuration is more consistent