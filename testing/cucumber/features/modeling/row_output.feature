Feature: Row output

  A row model's string output is a Gherkin representation of itself. As such, output from a row model can be used as
  input for the same kind of model.


  Scenario: Outputting a row model
    Given the following gherkin:
      """
      |foo|bar|
      """
    And a row model based on that gherkin
      """
        @model = CukeModeler::Row.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      | foo | bar |
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Row.new(@model.to_s)
      """
