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


  Scenario: The feature file's full path is modeled.
    Then the "path" of feature file "some_feature.feature" is "path_to/some_feature.feature"
    And  the "path" of feature file "just_a_placeholder.feature" is "path_to/just_a_placeholder.feature"

  Scenario: The feature file's name is modeled.
    Then the "name" of feature file "some_feature.feature" is "some_feature.feature"
    And  the "name" of feature file "just_a_placeholder.feature" is "just_a_placeholder.feature"

  Scenario: The feature file's feature is modeled.
    Then feature file "some_feature.feature" contains the feature "A test feature"
    And  feature file "just_a_placeholder.feature" contains no feature

  @redundant
  Scenario Outline: Feature file models pass all other specifications
  Exact specifications detailing the API for .feature file models.
    Given that there are "<additional specifications>" detailing models
    When the those specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications        |
    | feature_file_unit_spec.rb        |
    | feature_file_integration_spec.rb |
