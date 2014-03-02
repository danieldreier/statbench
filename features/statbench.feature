Feature: Compare data files

  Scenario: Summary comparison
  
    Default comparison gives plain English summary of 
    differences between two configurations (as represented
    by two data files given as arguments)

    Given two data files
    When I request a comparison
    Then I should be told which configuration is faster
    And I should be told which configuration is more consistent