Feature: Feature output

  A feature model's string output is a Gherkin representation of itself. As such, output from a feature model can be used as
  input for the same kind of model.


  Scenario: Outputting a feature model
    Given the following gherkin:
      """
      @tag1@tag2
      @tag3
      Feature: A feature with everything it could have
      Including a description
      and then some.
      Background:
      Background
      description
      * a step
      |value1|
      * another step
      @scenario_tag
      Scenario:
      Scenario
      description
      * a step
      * another step
      \"\"\"
        some text
      \"\"\"
      @outline_tag
      Scenario Outline:
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
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
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

        Background:

        Background
        description

          * a step
            | value1 |
          * another step

        @scenario_tag
        Scenario:

        Scenario
        description

          * a step
          * another step
            \"\"\"
              some text
            \"\"\"

        @outline_tag
        Scenario Outline:

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
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Feature.new(@model.to_s)
      """
