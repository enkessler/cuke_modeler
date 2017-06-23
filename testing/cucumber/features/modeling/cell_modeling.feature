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
