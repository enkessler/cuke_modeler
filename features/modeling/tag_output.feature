Feature: Tag output

  A tag model's string output is a Gherkin representation of itself.


  Scenario: Outputting a tag model
    Given the following gherkin:
      """
      @a_tag
      """
    And a scenario model based on that gherkin
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
