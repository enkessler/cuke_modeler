Feature: Features can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Features can be collected from:
    1. files
    2. directories


  Background: Setup test codebase
    Given a directory "feature_directory"
    And the following feature file "test_file_1.feature":
    """
    Feature: The test feature 1.
    """
    And the following feature file "empty.feature":
    """
    """
    And the file "test_file_1.feature" is read
    And the file "empty.feature" is read
    And a directory "feature_directory/nested_directory"
    And the following feature file "test_file_3.feature":
    """
    Feature: The test feature 3.
    """
    And the file "test_file_3.feature" is read
    When the directory "feature_directory" is read
    And the directory "feature_directory/nested_directory" is read


  Scenario: Features can be collected from files
    Then the features collected from file "1" are as follows:
      | The test feature 1. |
    Then the features collected from file "3" are as follows:
      | The test feature 3. |

  Scenario: Features can be collected from directories
    Then the features collected from directory "1" are as follows:
      | The test feature 1. |
      | The test feature 3. |
    And the features collected from directory "2" are as follows:
      | The test feature 3. |
