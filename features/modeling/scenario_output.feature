Feature: Scenario output

  A scenario model's string output is a Gherkin representation of itself.


  Scenario: Outputting a scenario model
    Given the following gherkin:
      """
      @tag1@tag2
      @tag3
      Scenario: A scenario with everything that it could have

      Including a description
      and then some.

      * a step
      |value|
      * another step
      \"\"\"
        some string
      \"\"\"
      """
    And a scenario model based on that gherkin
      """
        @model = CukeModeler::Scenario.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      @tag1 @tag2 @tag3
      Scenario: A scenario with everything that it could have

      Including a description
      and then some.

        * a step
          | value |
        * another step
          \"\"\"
            some string
          \"\"\"
      """
