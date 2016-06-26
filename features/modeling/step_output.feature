Feature: Outputting step models

  A step model's string output is a Gherkin representation of itself.


  Scenario: Outputting a step model

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
