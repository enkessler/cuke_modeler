Feature: Background output

  A background model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the background that it models.


  Background:
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


  Scenario: Stringify a background model
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

  Scenario: Inspect a background model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Background:<object_id> @name: "A background with everything that it could have">
      """
