Feature: Feature file modeling


  Feature file models represent a single .feature file in a test suite. They expose several attributes of the
  feature file that they represent, as well as containing the model for the feature that is present in that file.


  Background: An existing feature file
    Given the directory "test_directory"
    And the file "test_directory/foo.feature":
      """
      # A comment
      # Another comment
      Feature: Bar
      """
    And the feature file is modeled
      """
        @model = CukeModeler::FeatureFile.new('<path_to>/test_directory/foo.feature')
      """


  Scenario: Modeling a feature files's path
    When the feature file's path is requested
      """
        @model.path
      """
    Then the model returns "path_to/test_directory/foo.feature"

  Scenario: Modeling a feature files's name
    When the feature file's name is requested
      """
        @model.name
      """
    Then the model returns "foo.feature"

  Scenario: Modeling a feature file's comments
    When the feature file's comments are requested
      """
        @model.comments
      """
    Then the model returns models for the following comments:
      | # A comment       |
      | # Another comment |

  Scenario: Modeling a feature file's feature
    When the feature file's feature is requested
      """
        @model.feature
      """
    Then the model returns a model for the following feature:
      | Bar |
