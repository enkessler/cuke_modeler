@acceptance
Feature: Background modeling

  Background models represent the Background portion of a Cucumber feature.


  Background: Test file setup.
    Given the following feature file:
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
    When the file is modeled


  Scenario: The background's name is modeled.
    Then the background name is "Some general test setup stuff."


  @redundant
  Scenario Outline: Background models pass all other specifications
  Exact specifications detailing the API for background models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | background_unit_spec.rb   |
