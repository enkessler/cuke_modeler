Feature: Scenario output

  A scenario model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the scenario that it models.


  Background:
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


  Scenario: Stringify a scenario model
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
    And the output can be used to make an equivalent model
      """
      CukeModeler::Scenario.new(@model.to_s)
      """

  Scenario: Inspect a scenario model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Scenario:<object_id> @name: "A scenario with everything that it could have">
      """
