Feature: Table modeling

  Table models represent represent the table argument to a step. They expose several attributes of the table that they represent.


  Background:
    Given the following gherkin:
      """
      | value 1 | value 2 |
      | value 3 | value 4 |
      """
    And a table model based on that gherkin
      """
        @model = CukeModeler::Table.new(<source_text>)
      """


  Scenario: Modeling a table's rows
    When the table's rows are requested
      """
        @model.rows
      """
    Then the model returns models for the following rows:
      | value 1 | value 2 |
      | value 3 | value 4 |

  Scenario: Modeling a table's source line
    Given the following gherkin:
      """
      Feature:

        Scenario:
          * a step
            | value 1 |
            | value 2 |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the table model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block
      """
    When the table's source line is requested
      """
        @model.source_line
      """
    Then the model returns "5"
