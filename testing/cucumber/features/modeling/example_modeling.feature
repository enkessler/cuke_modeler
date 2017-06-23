Feature: Example modeling

  Example models represent an example table of a Scenario Outline portion of a feature. They expose several attributes of the example that they represent, as well as containing models for the example rows and tags that are present in that example.


  Background:
    Given the following gherkin:
      """
      @a_tag
      Examples: test example

          Some example description.

        Some more.
            Even more.

        | param 1 | param 2 |
        | value 1 | value 2 |
      """
    And an example model based on that gherkin
      """
        @model = CukeModeler::Example.new(<source_text>)
      """


  Scenario: Modeling an example's keyword
    When the example's keyword is requested
      """
        @model.keyword
      """
    Then the model returns "Examples"

  Scenario: Modeling an example's name
    When the example's name is requested
      """
        @model.name
      """
    Then the model returns "test example"

  Scenario: Modeling an example's description
    When the example's description is requested
      """
        @model.description
      """
    Then the model returns
      """
        Some example description.

      Some more.
          Even more.
      """

  Scenario: Modeling an example's rows
    When the example's rows are requested
      """
        @model.rows
      """
    Then the model returns models for the following rows:
      | param 1 | param 2 |
      | value 1 | value 2 |

  Scenario: Modeling an example's tags
    Given the following gherkin:
      """
      @feature_tag
      Feature:

        @outline_tag
        Scenario Outline:
          * a step

        @example_tag
        Examples:
          | param |
          | value |
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the example model inside of that feature model
      """
        @model = @model.tests.first.examples.first
      """
    When the example's tags are requested
      """
        @model.tags
      """
    Then the model returns models for the following tags:
      | @example_tag |
    When the example's inherited tags are requested
      """
        @model.applied_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag |
      | @outline_tag |
    When all of the example's tags are requested
      """
        @model.all_tags
      """
    Then the model returns models for the following tags:
      | @feature_tag |
      | @outline_tag |
      | @example_tag |

  Scenario: Modeling an example's source line
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
    And the example model inside of that feature model
      """
        @model = @model.tests.first.examples.first
      """
    When the example's source line is requested
      """
        @model.source_line
      """
    Then the model returns "5"
