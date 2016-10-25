Feature: Doc string output

  A doc string model's string output is a Gherkin representation of itself. As such, output from a doc string model can be used as
  input for the same kind of model.


  Scenario: Outputting a doc string model
    Given the following gherkin:
      """
      \"\"\" type foo
      Some text

        some more text

      \"\"\"
      """
    And a doc string model based on that gherkin
      """
        @model = CukeModeler::DocString.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      \"\"\" type foo
      Some text

        some more text

      \"\"\"
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::DocString.new(@model.to_s)
      """
