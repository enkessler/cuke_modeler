Feature: Feature file output

  A feature file model's string output is simply the file path of the feature file that it models and its
  most relevant attribute for inspection is the path of the feature file that it models.


  Background:
    Given a feature file model based on "some_feature_file.feature"


  Scenario: Stringify a feature file model
    When the model is output as a string
      """
      @model.to_s
      """
    Then the following text is provided:
      """
      <path_to>/some_feature_file.feature
      """
    And the output can be used to make an equivalent model
      """
      CukeModeler::FeatureFile.new(@model.to_s)
      """

  Scenario: Inspect a feature file model
    When the model is inspected
      """
      @model.inspect
      """
    Then the following text is provided:
      """
      #<CukeModeler::FeatureFile:<object_id> @path: "<path_to>/some_feature_file.feature">
      """
