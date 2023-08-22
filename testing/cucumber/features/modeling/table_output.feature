Feature: Table output

  A table model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the collection of rows of the table that it models.


  Background:
    Given the following gherkin:
      """
      |value1|value2|
      |value3|value4|
      """
    And a table model based on that gherkin
      """
      @model = CukeModeler::Table.new(<source_text>)
      """


  Scenario: Stringify a table model
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      | value1 | value2 |
      | value3 | value4 |
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Table.new(@model.to_s)
      """

  Scenario: Inspect a table model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Table:<object_id> @rows: [["value1", "value2"], ["value3", "value4"]]>
      """
