Feature: Outline modeling

  Outline models represent a Scenario Outline portion of a feature. They expose several attributes of the outline
  that they represent, as well as containing models for the steps, tags, and examples that are present in that outline.


  Background:
    Given the following gherkin:
      """
      Scenario Outline: example outline

          Some background description.

        Some more.
            Even more.


          Given a <setup> step
          When an action step
          Then a <verification> step

        Examples: example 1
          | setup | verification |
          | x     | y            |
        Examples: example 2
          | setup | verification |
          | a     | b            |
      """
    And an outline model based on that gherkin
      """
        @model = CukeModeler::Outline.new(<source_text>)
      """


  Scenario: Modeling an outline's keyword
    When the outline's keyword is requested
      """
        @model.keyword
      """
    Then the model returns "Scenario Outline"

  Scenario: Modeling an outline's name
    When the outline's name is requested
      """
        @model.name
      """
    Then the model returns "example outline"

  Scenario: Modeling an outline's description
    When the outline's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some background description.

      Some more.
          Even more.
      """

  Scenario: Modeling an outline's steps
    When the outline's steps are requested
      """
        @model.steps
      """
    Then the model returns models for the following steps:
      | a <setup> step        |
      | an action step        |
      | a <verification> step |

  Scenario: Modeling an outline's examples
    When the outline's examples are requested
      """
        @model.examples
      """
    Then the model returns models for the following examples:
      | example 1 |
      | example 2 |

  Scenario: Modeling an outline's tags
    Given the following gherkin:
      """
      @feature_tag
      Feature:

        @outline_tag_1
        @outline_tag_2
        Scenario Outline:
          Given a <setup> step
          When an action step
          Then a <verification> step

        Examples:
          | setup | verification |
          | x     | y            |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the outline model of that feature model
      """
        @model = @model.outlines.first
      """
    When the outline's tags are requested
      """
        @model.tags
      """
    Then the model returns models for the following tags:
      | @outline_tag_1 |
      | @outline_tag_2 |
    When the outline's inherited tags are requested
      """
        @model.applied_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag |
    When all of the outline's tags are requested
      """
        @model.all_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag   |
      | @outline_tag_1 |
      | @outline_tag_2 |

  Scenario: Modeling a outline's source line
    Given the following gherkin:
      """
      Feature:

        Scenario Outline:
          * a step
        Examples:
          | param |
          | value |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the outline model of that feature model
      """
        @model = @model.outlines.first
      """
    When the outline's source line is requested
      """
        @model.source_line
      """
    Then the model returns "3"
