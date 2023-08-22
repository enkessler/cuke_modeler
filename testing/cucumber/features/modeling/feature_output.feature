Feature: Feature output

  A feature model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the feature that it models.


  Background:
    Given the following gherkin:
      """
      @tag1@tag2
      @tag3
      Feature: A feature with everything it could have
      Including a description
      and then some.
      Background: non-nested background
      Background
      description
      * a step
      |value1|
      |value2|
      * another step
      @scenario_tag
      Scenario: non-nested scenario
      Scenario
      description
      * a step
      * another step
      \"\"\" with content type
        some text
      \"\"\"
      Rule: a rule
      Rule description
      Background: nested background
      * a step
      @outline_tag
      Scenario Outline: nested outline
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
      Rule: another rule
      Which is empty
      """
    And a feature model based on that gherkin
      """
      @model = CukeModeler::Feature.new(<source_text>)
      """


  Scenario: Stringify a feature model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Feature: A feature with everything it could have

      Including a description
      and then some.

        Background: non-nested background

        Background
        description

          * a step
            | value1 |
            | value2 |
          * another step

        @scenario_tag
        Scenario: non-nested scenario

        Scenario
        description

          * a step
          * another step
            \"\"\" with content type
              some text
            \"\"\"

        Rule: a rule

        Rule description

          Background: nested background
            * a step

          @outline_tag
          Scenario Outline: nested outline

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

        Rule: another rule

        Which is empty
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Feature.new(@model.to_s)
      """

  Scenario: Inspect a feature model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Feature:<object_id> @name: "A feature with everything it could have">
      """
