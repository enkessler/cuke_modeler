Feature: Comment modeling

  Comment models represent a comment portion of a feature. They expose several attributes of the comment that they represent.


  Background:
    Given the following gherkin:
      """
      # a comment
      """
    And a comment model based on that gherkin
      """
        @model = CukeModeler::Comment.new(<source_text>)
      """


  Scenario: Modeling a comments text
    When the comment's text is requested
      """
        @model.text
      """
    Then the model returns "# a comment"

  Scenario: Modeling a comment's source line
    Given a feature file with the following gherkin:
      """
      # a comment
      Feature:
      """
    And a feature file model based on that file
      """
        @model = CukeModeler::FeatureFile.new(<file_path>)
      """
    And the comment model of that feature file model
      """
        @model = @model.comments.first
      """
    When the comment's source line is requested
      """
        @model.source_line
      """
    Then the model returns "1"

  Scenario: Modeling a comment's source column
    Given a feature file with the following gherkin:
      """
      # a comment
      Feature:
      """
    And a feature file model based on that file
      """
        @model = CukeModeler::FeatureFile.new(<file_path>)
      """
    And the comment model of that feature file model
      """
        @model = @model.comments.first
      """
    When the comment's source column is requested
      """
        @model.source_column
      """
    Then the model returns "1"
