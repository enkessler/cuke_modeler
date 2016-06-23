Feature: Doc string modeling


  Doc string models represent represent the doc string argument to a step. They expose several attributes of the doc string
  that they represent.


  Background:
    Given the following gherkin:
      """
      \"\"\" type foo
      content bar
      \"\"\"
      """
    And a doc string model based on that gherkin
      """
        @model = CukeModeler::DocString.new(<source_text>)
      """


  Scenario: Modeling a doc string's content type
    When the doc string's name is requested
      """
        @model.content_type
      """
    Then the model returns "type foo"

  Scenario: Modeling a doc string's content
    When the doc string's content is requested
      """
        @model.contents
      """
    Then the model returns
      """
      content bar
      """

  @wip
  Scenario: Modeling a doc string's source line
    Given the following gherkin:
      """
      Feature:

        Scenario:
          * a step
            \"\"\"
            foo
            \"\"\"
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the doc string model inside of that feature model
      """
        @model = @model.tests.first.steps.first.block
      """
    When the doc string's source line is requested
      """
        @model.source_line
      """
    Then the model returns "3"
