Feature: Outputting table row elements

  A table row model's string output is a Gherkin representation of itself.


  Scenario: Outputting a table row model
    Given the following gherkin:
      """
      |foo|bar|
      """
    And a table row model based on that gherkin
      """
        @model = CukeModeler::TableRow.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      | foo | bar |
      """
