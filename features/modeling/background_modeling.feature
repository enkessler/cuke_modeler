Feature: Background modeling

  Background models represent the Background portion of a feature. They expose several attributes of the background
  that they represent, as well as containing models for the steps that are present in that background.


  Background:
    Given the following gherkin:
      """
      Background: Some general test setup stuff.

          Some background description.

        Some more.
            Even more.

        Given a setup step
        And another setup step
        When an action step
      """
    And a background model based on that gherkin
      """
        @model = CukeModeler::Background.new(<source_text>)
      """


  Scenario: Modeling a backgrounds's name
    When the background's name is requested
      """
        @model.name
      """
    Then the model returns "Some general test setup stuff."

  Scenario: Modeling a backgrounds's description
    When the background's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some background description.

      Some more.
          Even more.
      """

  Scenario: Modeling a backgrounds's steps
    When the background's steps are requested
      """
        @model.steps
      """
    Then the model returns models for the following steps:
      | a setup step       |
      | another setup step |
      | an action step     |

  Scenario: Modeling a backgrounds's source line
    Given the following gherkin:
      """
      Feature:

        Background:
          * a step
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the background model of that feature model
      """
        @model = @model.background
      """
    When the background's source line is requested
      """
        @model.source_line
      """
    Then the model returns "3"
