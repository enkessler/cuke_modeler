@gherkin3
Feature: Table elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a table can be modeled:
      - the table's contents
      - the table's raw element

    2. Tables can be outputted in a convenient form


  Background: Test file setup.
    Given the following feature file:
    """
    Feature:

      Scenario:
        * some data filled step:
          | value 1 | value 2 |
          | value 3 | value 4 |
        * some data filled step:
          | value 1 |
          | value 2 |
    """
    When the file is read


  Scenario: The table's contents are modeled.
    Then the step "1" table has the following contents:
      | value 1 | value 2 |
      | value 3 | value 4 |
    And the step "2" table has the following contents:
      | value 1 |
      | value 2 |

  Scenario: The raw table element is modeled.
    Then the table correctly stores its underlying implementation

  Scenario: Convenient output of a table
    Then the table has convenient output
