@gherkin3
Feature: Row elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a Row can be modeled:
      - the row's source line
      - the row's cells
      - the row's raw element

    2. Rows can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    Feature:

      Scenario Outline:
        * a step
      Examples:
        | param1 | param2 | extra param |
        | x      | y      |      ?      |
        | 1      | 2      |      3      |
      Examples:
        | param1 |
        | a      |
    """
    And parameter delimiters of "*" and "*"
    When the file is read


  Scenario: The raw row element is modeled.
    Then the test example block row correctly stores its underlying implementation

  Scenario: The row's source line is modeled.
    Then the test example block "1" row "1" is found to have the following properties:
      | source_line | 6 |
    And the test example block "1" row "2" is found to have the following properties:
      | source_line | 7 |
    And the test example block "1" row "3" is found to have the following properties:
      | source_line | 8 |
    And the test example block "2" row "1" is found to have the following properties:
      | source_line | 10 |
    And the test example block "2" row "2" is found to have the following properties:
      | source_line | 11 |

  Scenario: The row's cells are modeled.
    Then the test example block "1" row "1" cells are as follows:
      | param1      |
      | param2      |
      | extra param |
    And the test example block "1" row "2" cells are as follows:
      | x |
      | y |
      | ? |
    And the test example block "1" row "3" cells are as follows:
      | 1 |
      | 2 |
      | 3 |
    And the test example block "2" row "1" cells are as follows:
      | param1 |
    And the test example block "2" row "2" cells are as follows:
      | a |

  Scenario: Convenient output of a row
    Then the row has convenient output
