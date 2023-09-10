Feature: Doc string output

  A doc string model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the content of the doc string that it models.


  Background:
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


  Scenario: Stringify a doc string model
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

  Scenario: Inspect a doc string model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::DocString:<object_id> @content: "Some text\n\n  some more text\n">
      """
