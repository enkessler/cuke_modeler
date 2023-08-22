Feature: Rule output

  A rule model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the rule that it models.


  Background:
    Given the following gherkin:
      """
      @tag1@tag2
      @tag3
      Rule: A rule with everything it could have
      Including a description
      and then some.
      Background: a background
      Background
      description
      * a step
      |value1|
      |value2|
      * another step
      @scenario_tag
      Scenario: a scenario
      Scenario
      description
      * a step
      * another step
      \"\"\" with content type
        some text
      \"\"\"
      @outline_tag
      Scenario Outline: an outline
      Outline
      description
      * a step
      |value2|
      * another step
      \"\"\"
        some text
      \"\"\"
      @example_tag
      Examples:
      Example
      description
      |param|
      |value|
      Examples: additional example
      """
    And a rule model based on that gherkin
      """
      @model = CukeModeler::Rule.new(<source_text>)
      """


  @gherkin_min_version_18
  Scenario: Stringify a rule model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Rule: A rule with everything it could have

      Including a description
      and then some.

        Background: a background

        Background
        description

          * a step
            | value1 |
            | value2 |
          * another step

        @scenario_tag
        Scenario: a scenario

        Scenario
        description

          * a step
          * another step
            \"\"\" with content type
              some text
            \"\"\"

        @outline_tag
        Scenario Outline: an outline

        Outline
        description

          * a step
            | value2 |
          * another step
            \"\"\"
              some text
            \"\"\"

        @example_tag
        Examples:

        Example
        description

          | param |
          | value |

        Examples: additional example
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Rule.new(@model.to_s)
      """

  Scenario: Inspect a rule model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Rule:<object_id> @name: "A rule with everything it could have">
      """
