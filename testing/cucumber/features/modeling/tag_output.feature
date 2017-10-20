Feature: Tag output

  A tag model's string output is a Gherkin representation of itself. As such, output from a tag model can be used as input for the same kind of model.


  Scenario: Outputting a tag model
    Given the following gherkin:
      """
      @a_tag
      """
    And a tag model based on that gherkin
      """
        @model = CukeModeler::Tag.new(<source_text>)
      """
    When the model is output as a string
      """
        @model.to_s
      """
    Then the following text is provided:
      """
      @a_tag
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::Tag.new(@model.to_s)
      """
