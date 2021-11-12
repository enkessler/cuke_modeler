Feature: Feature modeling

Feature models are the top level element of the Gherkin portion of the model tree. They expose several attributes of the
feature that they represent, as well as containing models for any background, scenarios, or outlines that are present in
that feature.


  Background:
    Given the following gherkin:
      """
      @tag_1 @tag_2
      Feature: Feature Foo

          Some feature description.

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

        Rule: a rule

          Scenario: Scenario 3
            * a step

        Rule: another rule

          Scenario Outline: Outline 2
            * a step
          Examples:
            | param |
            | value |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """


  Scenario: Modeling a feature's keyword
    When the feature's keyword is requested
      """
        @model.keyword
      """
    Then the model returns "Feature"

  Scenario: Modeling a feature's name
    When the feature's name is requested
      """
        @model.name
      """
    Then the model returns "Feature Foo"

  Scenario: Modeling a feature's description
    When the feature's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some feature description.

      Some more.
          And some more.
      """

  Scenario: Modeling a feature's background
    When the feature's background is requested
      """
        @model.background
      """
    Then the model returns a model for the background "The background"

  Scenario: Modeling a feature's rules
    When the feature's rules are requested
      """
        @model.rules
      """
    Then the model returns models for the following rules:
      | a rule       |
      | another rule |

  Scenario: Modeling a feature's scenarios
  Note: Scenarios under a Rule keyword are included in the corresponding Rule model instead of the Feature model

    When the feature's scenarios are requested
      """
        @model.scenarios
      """
    Then the model returns models for the following scenarios:
      | Scenario 1 |
      | Scenario 2 |

  Scenario: Modeling a feature's outlines
  Note: Outlines under a Rule keyword are included in the corresponding Rule model instead of the Feature model

    When the feature's outlines are requested
      """
        @model.outlines
      """
    Then the model returns models for the following outlines:
      | Outline 1 |

  Scenario: Modeling a feature's tags

  Note: Although a feature does not inherit tags from anything else, they can still be requested in the same manner as other models that have tags.

    When the feature's tags are requested
      """
        @model.tags
      """
    Then the model returns models for the following tags:
      | @tag_1 |
      | @tag_2 |

  Scenario: Modeling a feature's source line
    When the feature's source line is requested
      """
        @model.source_line
      """
    Then the model returns "2"

  Scenario: Modeling a feature's source column
    When the feature's source column is requested
      """
        @model.source_column
      """
    Then the model returns "1"
