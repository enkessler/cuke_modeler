Feature: Model output

  All models can be output in text form via `#to_s`. For models that represent parts of the file structure, this text
  usually is a path. For models that represent parts of a feature file, this text usually is Gherkin. In any case, the
  output is in a format that can be used to create the same kind of model.

  Due to the nested nature of model relationships, the default output of `#inspect` can get...lengthy. For this reason,
  all models use a custom inspection method that provides a minimal but useful amount of information on the model
  object.

  See the model output documentation for specific models for details.


  Scenario: Stringify a model
    Given the models provided by CukeModeler
    Then all of them can be output as text appropriate to the model type
      """
      model = <model_class>.new
        
      model.to_s
      """

  Scenario: Inspect a model
    Given the models provided by CukeModeler
    Then all of them can provide a custom inspection output
      """
      model = <model_class>.new

      model.inspect
      """
    And the inspection values are of the form:
      """
      #<CukeModeler::<model_class>:<object_id> <some_meaningful_attribute>: <attribute_value>>
      """
