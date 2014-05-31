Feature: Steps can be collected from arbitrary parts of the codebase.


  Acceptance criteria

  Steps (both defined and undefined) can be collected from:
    1. backgrounds
    2. scenarios
    3. outlines
    4. features
    5. files
    6. directories


  Background: Setup test directories
    Given a directory "feature_directory"
    And the following feature file "test_file_1.feature":
    """
    Feature: The test feature 1.

      Background: Some general test setup stuff.
        Given a defined step
        And an undefined step

      Scenario: The scenario's name.
        Given another defined step
        Then another undefined step
    """
    And the file "test_file_1.feature" is read
    And a directory "feature_directory/nested_directory"
    And the following feature file "test_file_2.feature":
    """
    Feature: The test feature 2.

       Scenario Outline: The scenario outline's name.
        Given a defined step
        When another defined step
        Then *<this>* *step is* *<undefined>*
      Examples:
        | this | undefined |
        | x    | y         |
      Examples:
        | this | undefined |
        | a    | b         |
    """
    And the file "test_file_2.feature" is read
    And the following step definition file "some_step_defs.rb":
    """
    Given /^a defined step$/ do
      pending
    end
    """
    And the following step definition file "more_step_defs.rb":
    """
    Given /^another defined step$/ do
      pending
    end
    """
    When the step definition file "some_step_defs.rb" is read
    And the step definition file "more_step_defs.rb" is read
    And the directory "feature_directory" is read


  Scenario: Steps can be collected from backgrounds
    Then the steps collected from feature "1" background are as follows:
      | a defined step    |
      | an undefined step |
    And the "defined" steps collected from feature "1" background are as follows:
      | a defined step |
    And the "undefined" steps collected from feature "1" background are as follows:
      | an undefined step |

  Scenario: Steps can be collected from scenarios
    Then the steps collected from feature "1" test "1" are as follows:
      | another defined step   |
      | another undefined step |
    And the "defined" steps collected from feature "1" test "1" are as follows:
      | another defined step |
    And the "undefined" steps collected from feature "1" test "1" are as follows:
      | another undefined step |

  Scenario: Steps can be collected from scenario outlines
    Then the steps collected from feature "2" test "1" are as follows:
      | a defined step                   |
      | another defined step             |
      | *<this>* *step is* *<undefined>* |
    And the "defined" steps collected from feature "2" test "1" are as follows:
      | a defined step       |
      | another defined step |
    And the "undefined" steps collected from feature "2" test "1" are as follows:
      | *<this>* *step is* *<undefined>* |

  Scenario: Steps can be collected from features
    Then the steps collected from feature "1" are as follows:
      | a defined step         |
      | an undefined step      |
      | another defined step   |
      | another undefined step |
    And the "defined" steps collected from feature "1" are as follows:
      | a defined step       |
      | another defined step |
    And the "undefined" steps collected from feature "1" are as follows:
      | an undefined step      |
      | another undefined step |

  Scenario: Steps can be collected from files
    Then the steps collected from file "1" are as follows:
      | a defined step         |
      | an undefined step      |
      | another defined step   |
      | another undefined step |
    And the "defined" steps collected from file "1" are as follows:
      | a defined step       |
      | another defined step |
    And the "undefined" steps collected from file "1" are as follows:
      | an undefined step      |
      | another undefined step |

  Scenario: Steps can be collected from directories
    Then the steps collected from the directory are as follows:
      | a defined step                   |
      | an undefined step                |
      | another defined step             |
      | another undefined step           |
      | a defined step                   |
      | another defined step             |
      | *<this>* *step is* *<undefined>* |
    And the "defined" steps collected from the directory are as follows:
      | a defined step       |
      | another defined step |
      | a defined step       |
      | another defined step |
    And the "undefined" steps collected from the directory are as follows:
      | an undefined step                |
      | another undefined step           |
      | *<this>* *step is* *<undefined>* |
