Feature: Tests can be manipulated in various ways.


  Acceptance criteria

  Tests can be manipulated:
    1. outlines can have rows added and removed


  Background: Test file setup.
    Given the following feature file:
    """
    Feature: A feature containing our starting outline.

      Scenario Outline:
        Given this *parameterized* step takes a table:
          | <param1> |
          | <param2> |
        Then I don't really need another step
      Examples: Only one row to start with
        | param1 | param2 |
        | x      | y      |
    """
    And the file is read

  Scenario: Rows can be added to an outline
    When the test example block has the following rows added to it:
      | 1,2 |
    Then the test example block rows are as follows:
      | x,y |
      | 1,2 |

  Scenario: Rows can be removed from an outline
    When the test example block has the following rows removed from it:
      | x,y |
    Then the test example block has no rows
