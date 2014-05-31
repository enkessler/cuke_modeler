Feature: Feature files can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a .feature file can be modeled:
      - the file's name
      - the file's full path
      - the file's features (one or zero per file)

    2. Feature files can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file "test_file_1.feature":
    """
    Feature: The first test feature
      Just a dummy feature.
    """
    And the following feature file "test_file_2.feature":
    """
    Feature: The second test feature
      Just a dummy feature.
    """
    And the following feature file "why_would_you_make_an_empty_file.feature":
    """
    """
    When the file "test_file_1.feature" is read
    And the file "test_file_2.feature" is read
    And the file "why_would_you_make_an_empty_file.feature" is read


  Scenario: The file's feature is modeled.
    Then file "1" is found to have the following properties:
      | name          | test_file_1.feature         |
      | path          | path_to/test_file_1.feature |
      | feature_count | 1                           |
    And file "1" features are as follows:
      | The first test feature |
    Then file "2" is found to have the following properties:
      | name          | test_file_2.feature         |
      | path          | path_to/test_file_2.feature |
      | feature_count | 1                           |
    And file "2" features are as follows:
      | The second test feature |
    Then file "3" is found to have the following properties:
      | name          | why_would_you_make_an_empty_file.feature         |
      | path          | path_to/why_would_you_make_an_empty_file.feature |
      | feature_count | 0                                                |
    And file "3" has no features

  Scenario: Convenient output of a feature file
    Then the feature file has convenient output

  @redundant
  Scenario Outline: Feature file models pass all other specifications
  Exact specifications detailing the API for .feature file models.
    Given that there are "<additional specifications>" detailing models
    When the corresponding specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications        |
    | feature_file_unit_spec.rb        |
    | feature_file_integration_spec.rb |
