@acceptance
Feature: Feature modeling

  Feature models represent single Cucumber feature.


  Background: Test feature setup
    Given the following feature "populated_feature":
      """
      @tag_1 @tag_2
      @tag_3
      Feature: A perfectly normal feature

        Some feature description.

      Some more.
          And some more.

        Background: Some general test setup stuff.
          * some setup step

        Scenario: The first scenario's name.
        * a step

        Scenario Outline: The scenario outline's name.
          * a step
        Examples:
          | param |
          | x     |

        Scenario: The second scenario's name.
          * a step
      """
    And the following feature "empty_feature":
      """
      Feature: TBD
      """
    When the feature "populated_feature" is modeled
    And the feature "empty_feature" is modeled


  Scenario: The feature's name is modeled.
    Then the "name" of feature "populated_feature" is "A perfectly normal feature"
    And  the "name" of feature "empty_feature" is "TBD"

  @redundant
  Scenario Outline: Feature models pass all other specifications
  Exact specifications detailing the API for feature models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | feature_unit_spec.rb      |
