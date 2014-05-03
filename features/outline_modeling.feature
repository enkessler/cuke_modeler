@acceptance
Feature: Outline modeling

  Outline models represent a Scenario Outline portion of a Cucumber feature.


  Background: Test file setup.
    Given the following feature file:
      """
      @a_feature_level_tag
      Feature:

        @outline_tag
        Scenario Outline: Outline 1

          Some outline description.

        Some more.
            Even more.

          Given a <setup> step
          When an action step
          Then a <verification> step

        Examples: example 1
          | setup | verification |
          | x     | y            |
        Examples: example 2
          | setup | verification |
          | a     | b            |

        Scenario Outline:
      """
    When the file is modeled


  Scenario: The scenario's name is modeled.
    Then the first outline's name is "Outline 1"
    And  the second outline has no name


  @redundant
  Scenario Outline: Outline models pass all other specifications
  Exact specifications detailing the API for outline models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | outline_unit_spec.rb      |
