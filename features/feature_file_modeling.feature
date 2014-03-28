@acceptance
Feature: Feature file modeling

  Feature file models represent a single .feature file.


  Background: Test file setup
    Given the following feature file "some_feature.feature":
      """
      Feature: A test feature
      """
    And the following feature file "just_a_placeholder.feature":
      """
      """
    When the file "some_feature.feature" is modeled
    And the file "just_a_placeholder.feature" is modeled


  Scenario: The feature file's name is modeled.
    Then the "name" of feature file "some_feature.feature" is "some_feature.feature"
    And  the "name" of feature file "just_a_placeholder.feature" is "just_a_placeholder.feature"
