Feature: Scenario modeling

  Scenario models represent a Scenario portion of a feature. They expose several attributes of the scenario
  that they represent, as well as containing models for the steps and tags that are present in that scenario.


  Background:
    Given the following gherkin:
      """
      Scenario: example scenario

          Some background description.

        Some more.
            Even more.

        Given a setup step
        When an action step
        Then a verification step
      """
    And a scenario model based on that gherkin
      """
        @model = CukeModeler::Scenario.new(<source_text>)
      """


  Scenario: Modeling a scenario's name
    When the scenario's name is requested
      """
        @model.name
      """
    Then the model returns "example scenario"

  Scenario: Modeling a scenario's description
    When the scenario's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some background description.

      Some more.
          Even more.
      """

  Scenario: Modeling a scenario's steps
    When the scenario's steps are requested
      """
        @model.steps
      """
    Then the model returns models for the following steps:
      | a setup step        |
      | an action step      |
      | a verification step |

  Scenario: Modeling a scenario's tags
    Given the following gherkin:
      """
      @feature_tag
      Feature:

        @scenario_tag_1
        @scenario_tag_2
        Scenario:
          * a step
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the scenario model of that feature model
      """
        @model = @model.scenarios.first
      """
    When the scenario's tags are requested
      """
        @model.tags
      """
    Then the model returns models for the following tags:
      | @scenario_tag_1 |
      | @scenario_tag_2 |
    When the scenario's inherited tags are requested
      """
        @model.applied_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag |
    When all of the scenario's tags are requested
      """
        @model.all_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag    |
      | @scenario_tag_1 |
      | @scenario_tag_2 |

  Scenario: Modeling a scenario's source line
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
    And the scenario model of that feature model
      """
        @model = @model.scenarios.first
      """
    When the scenario's source line is requested
      """
        @model.source_line
      """
    Then the model returns "3"
