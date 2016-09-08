Feature: Table output

  A table model's string output is a Gherkin representation of itself.


  Scenario: Outputting a table model
    Given the following gherkin:
      """
      |value1|value2|
      |value3|value4|
      """
    And a table model based on that gherkin
      """
        @model = CukeModeler::Table.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      | value1 | value2 |
      | value3 | value4 |
      """
