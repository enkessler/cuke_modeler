Feature: Step modeling

  Step models represent represent the a step in a scenario, outline, or background. They expose several attributes of the step that they represent.


  Background:
    Given the following gherkin:
      """
      * a step
      """
    And a step model based on that gherkin
      """
        @model = CukeModeler::Step.new(<source_text>)
      """


  Scenario: Modeling a step's keyword
    When the step's keyword is requested
      """
        @model.keyword
      """
    Then the model returns "*"

  Scenario: Modeling a step's base text
    When the step's base text is requested
      """
        @model.text
      """
    Then the model returns "a step"

  Scenario: Modeling a step's source line
    Given the following gherkin:
      """
      Feature:

        Scenario:
          * a step
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the step model inside of that feature model
      """
        @model = @model.tests.first.steps.first
      """
    When the step's source line is requested
      """
        @model.source_line
      """
    Then the model returns "4"

  Scenario: Modeling a step's source column
    Given the following gherkin:
      """
      Feature:

        Scenario:
          * a step
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the step model inside of that feature model
      """
        @model = @model.tests.first.steps.first
      """
    When the step's source column is requested
      """
        @model.source_column
      """
    Then the model returns "5"

  Scenario: Modeling a step's table
    Given a step model based on the following gherkin:
      """
      * a step
        | value 1 |
        | value 2 |
      """
    When the step's table is requested
      """
        @model.block
      """
    Then the model returns a model for the following table:
      | value 1 |
      | value 2 |

  Scenario: Modeling a step's doc string
    Given a step model based on the following gherkin:
      """
      * a step
        \"\"\"
        some text
        \"\"\"
      """
    When the step's doc string is requested
      """
        @model.block
      """
    Then the model returns a model for the following doc string:
      """
      some text
      """
