Feature: Outputting example elements

  An example model's string output is a Gherkin representation of itself.


  Scenario: Outputting an example model
    Given the following gherkin:
      """
      @tag1
      @tag2 @tag3
      Examples: an example with everything that it could have

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
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Examples: an example with everything that it could have

      Some description.
      Some more description.

        | param1 | param2 |
        | value1 | value2 |
        | value3 | value4 |
      """
