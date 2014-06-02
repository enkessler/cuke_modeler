Feature: Test equality can be determined.


  Acceptance criteria

  Tests can be compared for equality.
    1. tests whose steps are the same except for arguments and keywords (i.e.
       they match the same step definition) are equal


  Background: Test file setup.
    Given the following feature file:
    """
    Feature: A feature with duplicate tests.

      Scenario: A test
        Given this *parameterized* step takes a table:
          | data 1 |
          | data 2 |
        And some setup step
        When a step with a *parameter*
        And a big step:
        \"\"\"
        little doc block
        \"\"\"
        Then *lots* *of* *parameters*

      Scenario: Same test, different arguments and keywords
        Given this *similarly parameterized* step takes a table:
          | data 3 |
          | data 4 |
        Given some setup step
        When a step with a *parameter*
        * a big step:
        \"\"\"
        A little
        bigger doc block
        \"\"\"
        Then *lots* *of* *parameters*

      Scenario Outline: This is the same test as an outline
        Given this *parameterized* step takes a table:
          | <param1> |
          | <param2> |
        And some setup step
        When a step with a *parameter*
        And a big step:
        \"\"\"
        little doc block
        \"\"\"
        Then *lots* *of* *parameters*
      Examples:
        | param1 | param2 |
        | x      | y      |
      Examples:
        | param1 | param2 |
        | a      | b      |

      Scenario Outline: Same outline, different arguments and keywords
        Given this *similarly parameterized* step takes a table:
          | <param3> |
          | <param4> |
        Given some setup step
        When a step with a *slightly different parameter*
        * a big step:
        \"\"\"
        A little
        bigger doc block
        \"\"\"
        Then *lots* *of effectively the same* *parameters*
      Examples:
        | param1 | param2 |
        | h      | k      |
      Examples:
        | param1 | param2 |
        | i      | j      |

      Scenario: A different test
        Given this *parameterized* step takes a table:
          | data 1 |
          | data 2 |
        And not the same setup step as before
        When a step with a *parameter*
        And a big step:
        \"\"\"
        little doc block
        \"\"\"
        Then *lots* *of* *parameters*

      Scenario Outline: This is the same different test as an outline
        Given this *similarly parameterized* step takes a table:
          | <param1> |
          | <param2> |
        And not the same setup step as before
        When a step with a *slightly different parameter*
        And a big step:
        \"\"\"
        A little
        bigger doc block
        \"\"\"
        Then *lots* *of effectively the same* *parameters*
      Examples:
        | param1 | param2 |
        | x      | y      |
      Examples:
        | param1 | param2 |
        | a      | b      |
    """
    And parameter delimiters of "*" and "*"
    When the file is read


  Scenario: Scenario to Scenario comparison
    Then test "1" is equal to test "2"
    And test "1" is not equal to test "5"

  Scenario: Outline to Outline comparison
    Then test "3" is equal to test "4"
    And test "3" is not equal to test "6"

  Scenario: Scenario to Outline comparison
    Then test "1" is equal to test "3"
    And test "1" is not equal to test "6"
