Feature: Model output

  All models can be output in text form. For models that represent parts of the file structure, this text
  will be a path. For models that represent parts of a feature file, this text will be Gherkin. See the
  model output documentation for specific models for details.


  Scenario: Outputting a model element
    Given the element models provided by CukeModeler
    Then  all of them can be output as text appropriate to the model type
      """
        model = <model_class>.new
        
        model.to_s
      """
