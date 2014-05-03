@acceptance
Feature: Scenario modeling

  Scenario models represent a Scenario portion of a Cucumber feature.


  Background: Test file setup.
    Given the following feature file:
      """
      @a_feature_level_tag
      Feature:

        @a_tag
        @another_tag
        Scenario: Scenario 1

          Some scenario description.

        Some more.
            Even more.

          Given a setup step
          When an action step
          Then a verification step

        Scenario:
      """
    When the file is modeled


  Scenario: The scenario's name is modeled.
    Then the first scenario's name is "Scenario 1"
    And  the second scenario has no name


  @redundant
  Scenario Outline: Scenario models pass all other specifications
  Exact specifications detailing the API for scenario models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | scenario_unit_spec.rb     |
