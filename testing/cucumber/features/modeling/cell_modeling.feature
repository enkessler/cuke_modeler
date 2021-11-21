Feature: Cell modeling

  Cell models represent an individual cell in a table row (either a step table or an example table). They expose several attributes of the cell that they represent.


  Background:
    Given the following gherkin:
      """
      foo
      """
    And a cell model based on that gherkin
      """
        @model = CukeModeler::Cell.new(<source_text>)
      """


  Scenario: Modeling a cell's value
    When the cell's value is requested
      """
        @model.value
      """
    Then the model returns "foo"

  Scenario: Modeling a cell's source line
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
    And the cell model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block.rows.first.cells.first
      """
    When the cell's source line is requested
      """
        @model.source_line
      """
    Then the model returns "5"

  Scenario: Modeling a cell's source column
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
    And the cell model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block.rows.first.cells.first
      """
    When the cell's source column is requested
      """
        @model.source_column
      """
    Then the model returns "9"
