Feature: Feature file output

  A feature file model's string output is simply the file path of the feature file that it models. As such, output from a feature file model can be used as input for the same kind of model.


  Scenario: Outputting a feature file model
    Given a feature file model based on "some_feature_file.feature"
    When it is outputted
    Then the following text is provided:
      """
      <path_to>/some_feature_file.feature
      """
    And the output can be used to make an equivalent model
      """
        CukeModeler::FeatureFile.new(@model.to_s)
      """
