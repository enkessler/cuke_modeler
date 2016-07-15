Feature: Cell output

  A cell model's string output is a Gherkin representation of itself.


  Scenario: Outputting a cell model
    Given the following gherkin:
      """
      foo
      """
    And a cell model based on that gherkin
      """
        @model = CukeModeler::Cell.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      foo
      """
