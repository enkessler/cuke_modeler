Feature: Tags can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Tags can be collected from:
    1. scenarios
    2. outlines
    3. features
    4. files
    5. directories


  Background: Setup test codebase
    Given a directory "feature_directory"
    And the following feature file "test_file_1.feature":
    """
    @feature_tag_1
    Feature: The test feature 1.

      @scenario_tag_1
      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step

      @outline_tag_1
      Scenario Outline: The scenario outline's name.
        Given the first "<param1>"
        When the second "<param2>"
        Then the third step
      @example_tag_1
      Examples: text describing the significance of the examples
        | param1 | param2 |
        | x      | y      |
      @example_tag_2
      Examples: some examples with different significance and a tag
        | param1 | param2 |
        | a      | b      |
    """
    And the file "test_file_1.feature" is read
    And a directory "feature_directory/nested_directory"
    And the following feature file "test_file_2.feature":
    """
    @feature_tag_2
    Feature: The test feature 2.

      @scenario_tag_2
      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the file "test_file_2.feature" is read
    When the directory "feature_directory" is read

  Scenario: Tags can be collected from scenarios
    Then the tags collected from feature "1" test "1" are as follows:
      | @scenario_tag_1 |

  Scenario: Tags can be collected from scenario outlines
    Then the tags collected from feature "1" test "2" are as follows:
      | @outline_tag_1 |
      | @example_tag_1 |
      | @example_tag_2 |

  Scenario: Tags can be collected from features
    Then the tags collected from feature "1" are as follows:
      | @feature_tag_1  |
      | @scenario_tag_1 |
      | @outline_tag_1  |
      | @example_tag_1  |
      | @example_tag_2  |

  Scenario: Tags can be collected from files
    Then the tags collected from file "1" are as follows:
      | @feature_tag_1  |
      | @scenario_tag_1 |
      | @outline_tag_1  |
      | @example_tag_1  |
      | @example_tag_2  |

  Scenario: Tags can be collected from directories
    Then the tags collected from directory are as follows:
      | @feature_tag_1  |
      | @scenario_tag_1 |
      | @outline_tag_1  |
      | @example_tag_1  |
      | @example_tag_2  |
      | @feature_tag_2  |
      | @scenario_tag_2 |
