Feature: Background output

  A background model's string output is a Gherkin representation of itself. As such, output from a background model can be used as
  input for the same kind of model.


  Scenario: Outputting a background model
    Given the following gherkin:
      """
      Background: A background with everything that it could have

      Including a description
      and then some.

      * a step
      |value|
      * another step
      \"\"\"
        some string
      \"\"\"
      """
    And a background model based on that gherkin
      """
        @model = CukeModeler::Background.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      Background: A background with everything that it could have

      Including a description
      and then some.

        * a step
          | value |
        * another step
          \"\"\"
            some string
          \"\"\"
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Background.new(@model.to_s)
      """
