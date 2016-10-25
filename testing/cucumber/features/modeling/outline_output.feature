Feature: Outline output

  An outline model's string output is a Gherkin representation of itself. As such, output from an outline model can be used as
  input for the same kind of model.


  Scenario: Outputting an outline model
    Given the following gherkin:
      """
      @tag1@tag2
      @tag3
      Scenario Outline: An outline with everything that it could have

      Some description.
      Some more description.

      * a step
      |value|
      * a <value> step
      \"\"\"
        some string
      \"\"\"

      Examples:
      Some description.
      Some more description.
      | value |
      | x     |
      @example_tag

      Examples:
      | value |
      | y     |
      """
    And an outline model based on that gherkin
      """
        @model = CukeModeler::Outline.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Scenario Outline: An outline with everything that it could have

      Some description.
      Some more description.

        * a step
          | value |
        * a <value> step
          \"\"\"
            some string
          \"\"\"

      Examples:

      Some description.
      Some more description.

        | value |
        | x     |

      @example_tag
      Examples:
        | value |
        | y     |
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Outline.new(@model.to_s)
      """
