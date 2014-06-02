Feature: Table Row elements can be modeled.


  Acceptance criteria

    1. All conceptual pieces of a table row can be modeled:
      - the row's source line
      - the row's cells
      - the row's raw element

    2. Rows can be outputted in a convenient form


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


  Scenario: The raw table row element is modeled.
    Then the step table row correctly stores its underlying implementation

  Scenario: The table row's source line is modeled.
    Then step "1" table row "1" is found to have the following properties:
      | source_line | 5 |
    And step "1" table row "2" is found to have the following properties:
      | source_line | 6 |
    And step "2" table row "1" is found to have the following properties:
      | source_line | 8 |
    And step "2" table row "2" is found to have the following properties:
      | source_line | 9 |

  Scenario: The table row's cells are modeled.
    Then step "1" table row "1" cells are as follows:
      | value 1 |
      | value 2 |
    And step "1" table row "2" cells are as follows:
      | value 3 |
      | value 4 |
    And step "2" table row "1" cells are as follows:
      | value 1 |
    And step "2" table row "2" cells are as follows:
      | value 2 |

  Scenario: Convenient output of a table row
    Then the table row has convenient output

  @redundant
  Scenario Outline: Table row models pass all other specifications
  Exact specifications detailing the API for table table row models.
    Given that there are "<additional specifications>" detailing models
    When the corresponding specifications are run
    Then all of those specifications are met
  Examples:
    | additional specifications     |
    | table_row_unit_spec.rb        |
    | table_row_integration_spec.rb |
