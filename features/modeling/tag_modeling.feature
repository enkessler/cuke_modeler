Feature: Tag modeling

  Tag models represent a tag portion of a feature. They expose several attributes of the tag
  that they represent.


  Background:
    Given the following gherkin:
      """
      @a_tag
      """
    And a tag model based on that gherkin
      """
        @model = CukeModeler::Tag.new(<source_text>)
      """


  Scenario: Modeling a tag's name
    When the tag's name is requested
      """
        @model.name
      """
    Then the model returns "@a_tag"


  Scenario: Modeling a tag's source line
    Given the following gherkin:
      """
      @a_tag
      Feature:
      """
    And a feature model based on that gherkin
      """
        @model = CukeModeler::Feature.new(<source_text>)
      """
    And the tag model of that feature model
      """
        @model = @model.tags.first
      """
    When the tag's source line is requested
      """
        @model.source_line
      """
    Then the model returns "1"
