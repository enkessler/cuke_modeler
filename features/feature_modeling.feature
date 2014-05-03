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

        Background: The background
          * some setup step

        Scenario: Scenario 1
        * a step

        Scenario Outline: Outline 1
          * a step
        Examples:
          | param |
          | x     |

        Scenario: Scenario 2
          * a step
      """
    And the following feature "empty_feature":
      """
      Feature:
      """
    When the feature "populated_feature" is modeled
    And the feature "empty_feature" is modeled


  Scenario: The feature's name is modeled.
    Then the name of feature "populated_feature" is "A perfectly normal feature"
    And  feature "empty_feature" has no name

  Scenario: The feature's source line is modeled.
    Then the source line of feature "populated_feature" is "3"
    Then the source line of feature "empty_feature" is "1"

  Scenario: The feature's description is modeled.
    Then the feature "populated_feature" has the following description:
      """

      Some feature description.

      Some more.
        And some more.
      """
    And the feature "empty_feature" has no description

  Scenario: The feature's tags are modeled.
    Then the feature "populated_feature" has the following tags:
      | @tag_1 |
      | @tag_2 |
      | @tag_3 |
    And the feature "empty_feature" has no tags

  Scenario: The feature's scenarios are modeled.
    Then the feature "populated_feature" has the following scenarios:
      | Scenario 1 |
      | Scenario 2 |
    And the feature "empty_feature" has no scenarios

  Scenario: The feature's outlines are modeled.
    Then the feature "populated_feature" has the following outlines:
      | Outline 1 |
    And the feature "empty_feature" has no outlines

  Scenario: The feature's background is modeled.
    Then the background of feature "populated_feature" is "The background"
    And feature "empty_feature" has no background


  @redundant
  Scenario Outline: Feature models pass all other specifications
  Exact specifications detailing the API for feature models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications   |
    | feature_unit_spec.rb        |
    | feature_integration_spec.rb |
