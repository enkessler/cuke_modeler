Feature: Feature files can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Feature files can be collected from:
    1. directories


  Background: Setup test codebase
    Given a directory "feature_directory"
    And a directory "feature_directory/nested_directory_1"
    And the following feature file "test_file_1.feature":
    """
    Feature: The test feature 1.
    """
    And the file "test_file_1.feature" is read
    And a directory "feature_directory/nested_directory_2"
    And the following feature file "test_file_2.feature":
    """
    Feature: The test feature 2.
    """
    And the file "test_file_2.feature" is read
    When the directory "feature_directory" is read
    And the directory "feature_directory/nested_directory_1" is read
    And the directory "feature_directory/nested_directory_2" is read


  Scenario: Feature files can be collected from directories
    Then the files collected from directory "1" are as follows:
      | test_file_1.feature |
      | test_file_2.feature |
    And the files collected from directory "2" are as follows:
      | test_file_1.feature |
    And the files collected from directory "3" are as follows:
      | test_file_2.feature |
