@acceptance
Feature: Background modeling

  Background models represent the Background portion of a Cucumber feature.


  Background: Test file setup.
    Given the following feature:
      """
      Feature:

        Background: Some general test setup stuff.

          Some background description.

        Some more.
            Even more.

          Given a setup step
          And another setup step
          When an action step
      """
    And the following feature:
      """
      Feature:
        Background:
      """
    When the backgrounds are modeled


  Scenario: The background's source line is modeled.
    Then the source line of the first background is "3"
    And the source line of the second background is "2"

  Scenario: The background's name is modeled.
    Then the first background's name is "Some general test setup stuff."
    And the second background has no name

  Scenario: The background description is modeled.
    Then the first background has the following description:
      """

      Some background description.

      Some more.
        Even more.
      """
    Then the second background has no description

  Scenario: The background's steps are modeled.
    Then the first background has the following steps:
      | a setup step       |
      | another setup step |
      | an action step     |
    And the second background has no steps


  @redundant
  Scenario Outline: Background models pass all other specifications
  Exact specifications detailing the API for background models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications      |
    | background_unit_spec.rb        |
    | background_integration_spec.rb |
