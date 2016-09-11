Feature: Feature file output

  A feature file model's string output is simply the file path of the feature file that it models.


  Scenario: Outputting a feature file model
    Given a feature file model based on "some_feature_file.feature"
    When it is outputted
    Then the following text is provided:
      """
      <path_to>/some_feature_file.feature
      """
