Feature: Directories can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Directories containing feature files can be collected from:
    1. directories


  Background: Setup test codebase
    Given a directory "feature_directory"
    And a directory "feature_directory/nested_directory_1"
    And a directory "feature_directory/nested_directory_1/nested_directory_2"
    When the directory "feature_directory" is read
    And the directory "feature_directory/nested_directory_1" is read
    And the directory "feature_directory/nested_directory_1/nested_directory_2" is read


  Scenario: Directories can be collected from directories
    Then the directories collected from directory "1" are as follows:
      | nested_directory_1 |
      | nested_directory_2 |
    And the directories collected from directory "2" are as follows:
      | nested_directory_2 |
    And there are no directories collected from directory "3"
