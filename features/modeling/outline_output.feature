Feature: Outputting outline models

  A outline model's string output is a Gherkin representation of itself.


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
