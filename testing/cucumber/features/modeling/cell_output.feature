Feature: Cell output

  A cell model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the value of the cell that it models.


  Background:
    Given the following gherkin:
      """
      foo
      """
    And a cell model based on that gherkin
      """
      @model = CukeModeler::Cell.new(<source_text>)
      """


  Scenario: Stringify a cell model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      foo
      """

  Scenario: Inspect a cell model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Cell:<object_id> @value: "foo">
      """
