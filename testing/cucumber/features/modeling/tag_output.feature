Feature: Tag output

  A tag model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the name of the tag that it models.


  Background:
    Given the following gherkin:
      """
      @a_tag
      """
    And a tag model based on that gherkin
      """
      @model = CukeModeler::Tag.new(<source_text>)
      """


  Scenario: Stringify a tag model
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

  Scenario: Inspect a tag model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Tag:<object_id> @name: "@a_tag">
      """
