Feature: Example output

  An example model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the example that it models.


  Background:
    Given the following gherkin:
      """
      @tag1
      @tag2 @tag3
      Examples: An example with everything that it could have

      Some description.
      Some more description.

      |param1|param2|
      |value1|value2|
      |value3|value4|
      """
    And an example model based on that gherkin
      """
      @model = CukeModeler::Example.new(<source_text>)
      """


  Scenario: Stringify an example model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Examples: An example with everything that it could have

      Some description.
      Some more description.

        | param1 | param2 |
        | value1 | value2 |
        | value3 | value4 |
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Example.new(@model.to_s)
      """

  Scenario: Inspect an example model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Example:<object_id> @name: "An example with everything that it could have">
      """
