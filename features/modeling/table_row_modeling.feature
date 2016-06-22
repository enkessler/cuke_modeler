Feature: Table row modeling

  Table row models represent an individual row in a step table. They expose several attributes of the row
  that they represent.


  Background:
    Given the following gherkin:
      """
      | foo | bar |
      """
    And a table row model based on that gherkin
      """
        @model = CukeModeler::TableRow.new(<source_text>)
      """


  Scenario: Modeling a table rows's cells
    When the table rows's cells are requested
      """
        @model.cells
      """
    Then the model returns the following values:
      | foo |
      | bar |

  Scenario: Modeling a table row's source line
    Given the following gherkin:
      """
      Feature:

        Scenario:
          * a step
            | foo |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the table row model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block.rows.first
      """
    When the table rows's source line is requested
      """
        @model.source_line
      """
    Then the model returns "5"
