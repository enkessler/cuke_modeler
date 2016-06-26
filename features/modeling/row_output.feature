Feature: Outputting row models

  A row model's string output is a Gherkin representation of itself.


  Scenario: Outputting a row model
    Given the following gherkin:
      """
      |foo|bar|
      """
    And a row model based on that gherkin
      """
        @model = CukeModeler::Row.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      | foo | bar |
      """
