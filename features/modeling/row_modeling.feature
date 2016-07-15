Feature: Row modeling

  Row models represent an individual row in an examples table. They expose several attributes of the row
  that they represent.


  Background:
    Given the following gherkin:
      """
      | foo | bar |
      """
    And a row model based on that gherkin
      """
        @model = CukeModeler::Row.new(<source_text>)
      """


  Scenario: Modeling a rows's cells
    When the rows's cells are requested
      """
        @model.cells
      """
    Then the model returns models for the following cells:
      | foo |
      | bar |

  Scenario: Modeling a row's source line
    Given the following gherkin:
      """
      Feature:

        Scenario Outline:
          * a step
        Examples:
          | param | row |
          | value | row |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the row model inside of that feature model
      """
        @model = @model.tests.first.examples.first.rows.first
      """
    When the rows's source line is requested
      """
        @model.source_line
      """
    Then the model returns "6"
