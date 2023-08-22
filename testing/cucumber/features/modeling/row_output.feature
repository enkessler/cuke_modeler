Feature: Row output

  A row model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the collection of cells of the row that it models.


  Background:
    Given the following gherkin:
      """
      |foo|bar|
      """
    And a row model based on that gherkin
      """
      @model = CukeModeler::Row.new(<source_text>)
      """


  Scenario: Stringify a row model
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

  Scenario: Inspect a row model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Row:<object_id> @cells: ["foo", "bar"]>
      """
