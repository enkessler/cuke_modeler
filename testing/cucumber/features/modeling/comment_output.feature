Feature: Comment output

  A comment model's string output is a Gherkin representation of itself and its most relevant attribute for
  inspection is the text of the comment that it models.


  Background:
    Given the following gherkin:
      """
      # a comment
      """
    And a comment model based on that gherkin
      """
      @model = CukeModeler::Comment.new(<source_text>)
      """


  Scenario: Stringify a comment model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      # a comment
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::Comment.new(@model.to_s)
      """

  Scenario: Inspect a comment model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::Comment:<object_id> @text: "# a comment">
      """
