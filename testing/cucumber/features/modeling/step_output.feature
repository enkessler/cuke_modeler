Feature: Step output

  A step model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the text of the step that it models.


  Background:

  Note: Outputting a step that has a doc string is accomplished in the same manner

    Given the following gherkin:
      """
      * a step
        |value1|
        |value2|
      """
    And a step model based on that gherkin
      """
      @model = CukeModeler::Step.new(<source_text>)
      """


  Scenario: Stringify a step model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      * a step
        | value1 |
        | value2 |
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Step.new(@model.to_s)
      """

  Scenario: Inspect a step model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Step:<object_id> @text: "a step">
      """
