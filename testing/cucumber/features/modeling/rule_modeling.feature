Feature: Rule modeling

Rule models Scenario portion of a feature. They expose several attributes of the rule that they represent, as well as
containing models for any background, scenarios, or outlines that are present in that rule.


  Background:
    Given the following gherkin:
      """
      Rule: Rule Foo

          Some rule description.

        Some more.
            And some more.

        Background: The background
          * some setup step

        Scenario: Scenario 1
          * a step

        Scenario Outline: Outline 1
          * a step
        Examples:
          | param |
          | value |

        Scenario: Scenario 2
          * a step
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Rule.new(<source_text>)
      """


  Scenario: Modeling a rule's keyword
    When the rule's keyword is requested
      """
        @model.keyword
      """
    Then the model returns "Rule"

  Scenario: Modeling a rule's name
    When the rule's name is requested
      """
        @model.name
      """
    Then the model returns "Rule Foo"

  Scenario: Modeling a rule's description
    When the rule's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some rule description.

      Some more.
          And some more.
      """

  Scenario: Modeling a rule's background
    When the rule's background is requested
      """
        @model.background
      """
    Then the model returns a model for the background "The background"

  Scenario: Modeling a rule's scenarios
    When the rule's scenarios are requested
      """
        @model.scenarios
      """
    Then the model returns models for the following scenarios:
      | Scenario 1 |
      | Scenario 2 |

  Scenario: Modeling a rule's outlines
    When the rule's outlines are requested
      """
        @model.outlines
      """
    Then the model returns models for the following outlines:
      | Outline 1 |

  Scenario: Modeling a rule's source line
    Given the following gherkin:
      """
      Feature:

        Rule:
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the rule model of that feature model
      """
        @model = @model.rules.first
      """
    When the rule's source line is requested
      """
        @model.source_line
      """
    Then the model returns "3"
