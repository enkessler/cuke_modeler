Feature: Row modeling

  Row models represent an individual row in a step or example table. They expose several attributes of the row
  that they represent.


  Background:
    Given the following gherkin:
      """
      | foo | bar |
      """
    And a row model based on that gherkin
      """
        @model = CukeModeler::Row.new(<source_text>)
      """


  Scenario: Modeling a rows's cells
    When the rows's cells are requested
      """
        @model.cells
      """
    Then the model returns models for the following cells:
      | foo |
      | bar |

  Scenario: Modeling a row's source line
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
    And the row model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block.rows.first
      """
    When the rows's source line is requested
      """
        @model.source_line
      """
    Then the model returns "5"
