Feature: Tests can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Tests can be collected from:
    1. features
    2. files
    3. directories


  Background: Setup test codebase
    Given a directory "feature_directory"
    And the following feature file "test_file_1.feature":
    """
    Feature: The test feature 1.

      Scenario: Test 1
        Given the first step
        When the second step
        Then the third step

      Scenario Outline: Test 2
        Given the first "<param1>"
        When the second "<param2>"
        Then the third step
      Examples: text describing the significance of the examples
        | param1 | param2 |
        | x      | y      |
      Examples: some examples with different significance and a tag
        | param1 | param2 |
        | a      | b      |
    """
    And the file "test_file_1.feature" is read
    And a directory "feature_directory/nested_directory"
    And the following feature file "test_file_2.feature":
    """
    Feature: The test feature 2.

      Scenario: Test 3
        Given the first step
        When the second step
        Then the third step
    """
    And the file "test_file_2.feature" is read
    When the directory "feature_directory" is read
    And the directory "feature_directory/nested_directory" is read

  Scenario: Tests can be collected from features
    Then the tests collected from feature "1" are as follows:
      | Test 1 |
      | Test 2 |
    Then the tests collected from feature "2" are as follows:
      | Test 3 |

  Scenario: Tests can be collected from files
    Then the tests collected from file "1" are as follows:
      | Test 1 |
      | Test 2 |
    Then the tests collected from file "2" are as follows:
      | Test 3 |

  Scenario: Tests can be collected from directories
    Then the tests collected from directory "1" are as follows:
      | Test 1 |
      | Test 2 |
      | Test 3 |
    And the tests collected from directory "2" are as follows:
      | Test 3 |
