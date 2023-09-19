Then(/^all of them can be output as text appropriate to the model type$/) do |code_text|
  original_text = code_text

  @available_model_classes.each do |clazz|
    code_text = original_text.gsub('<model_class>', clazz.to_s)

    expect(clazz.instance_method(:to_s).owner).to equal(clazz), "#{clazz} does not override #to_s"

    # Make sure that the example code is valid
    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^all of them can provide a custom inspection output$/) do |code_text|
  original_text = code_text

  @available_model_classes.each do |clazz|
    code_text = original_text.gsub('<model_class>', clazz.to_s)

    expect(clazz.instance_method(:inspect).owner).to equal(clazz), "#{clazz} does not override #inspect"

    # Make sure that the example code is valid
    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the following text is provided:$/) do |expected_text|
  expected_text = expected_text.sub('<path_to>', @root_test_directory)
                               .sub('<object_id>', @model.object_id.to_s)

  expect(@output).to eq(expected_text)
end

And(/^the inspection values are of the form:$/) do |expected_pattern|
  original_pattern = expected_pattern

  @available_model_classes.each do |clazz|
    next if clazz == CukeModeler::Model

    model = clazz.new
    output = model.inspect

    expected_pattern = original_pattern.sub('<model_class>', clazz.to_s.match(/CukeModeler::(.*)/)[1])
                                       .sub('<object_id>', model.object_id.to_s)
                                       .sub('<some_meaningful_attribute>', '@\w+')
                                       .sub('<attribute_value>', '.*')

    message = "#{clazz} did not provide the expected inspection value\nexpected: #{expected_pattern}\nactual: #{output}"
    expect(output).to match(expected_pattern), message
  end
end

But(/^the base model class inspection value is of the form:$/) do |expected_pattern|
  clazz  = CukeModeler::Model
  model  = clazz.new
  output = model.inspect

  expected_pattern = expected_pattern.sub('<model_class>', clazz.to_s.match(/CukeModeler::(.*)/)[1])
                                     .sub('<object_id>', model.object_id.to_s)

  message = "#{clazz} did not provide the expected inspection value\nexpected: #{expected_pattern}\nactual: #{output}"
  expect(output).to match(expected_pattern), message
end

Then(/^all of them can be contained inside of another model$/) do |code_text|
  original_text = code_text

  @available_model_classes.each do |clazz|
    code_text = original_text.gsub('<model_class>', clazz.to_s)

    expect(clazz.new).to respond_to(:parent_model)

    # Make sure that the example code is valid
    expect { eval(code_text) }.to_not raise_error
  end
end

And(/^all of them can contain other models$/) do |code_text|
  original_text = code_text

  @available_model_classes.each do |clazz|
    code_text = original_text.gsub('<model_class>', clazz.to_s)

    expect(clazz.new).to respond_to(:children)

    # Make sure that the example code is valid
    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^all of them can be created without further context$/) do |code_text|
  original_text = code_text

  @available_model_classes.each do |clazz|
    code_text = original_text.gsub('<model_class>', clazz.to_s)

    expect { clazz.new }.to_not raise_error

    # Make sure that the example code is valid
    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the model returns "([^"]*)"$/) do |value|
  value.gsub!('path_to', @root_test_directory) if value.is_a?(String)
  value = value.to_i if value =~ /^\d+$/

  expect(@result).to eq(value)
end

Then(/^the model returns$/) do |value|
  value = value.gsub('path_to', @root_test_directory) if value.is_a?(String)

  expect(@result).to eq(value)
end

Then(/^the model returns models for the following feature files:$/) do |file_names|
  file_names = file_names.raw.flatten

  expect(@result.map(&:name)).to match_array(file_names)
end

Then(/^the model returns models for the following directories:$/) do |directory_names|
  directory_names = directory_names.raw.flatten

  expect(@result.map(&:name)).to match_array(directory_names)
end

And(/^the output can be used to make an equivalent model$/) do |code_text|
  clazz = @model.class

  base_output = @model.to_s
  remodeled_output = clazz.new(base_output).to_s

  expect(remodeled_output).to eq(base_output)

  # Make sure that the example code is valid
  expect { eval(code_text) }.to_not raise_error
end

Then(/^all of them provide access to the parsing data that was used to create them$/) do |code_text|
  original_text = code_text
  unparsed_models = [CukeModeler::Model, CukeModeler::Directory]

  @available_model_classes.each do |clazz|
    next if unparsed_models.include?(clazz)

    expect(clazz.new).to respond_to(:parsing_data)

    # Make sure that the example code is valid
    code_text = original_text.gsub('<model_class>', clazz.to_s)
    code_text.gsub!('<source_text>', '')

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the custom model inspection is used$/) do
  @available_model_classes.each do |clazz|
    expected_pattern = if clazz == CukeModeler::Model
                         '#<CukeModeler::<model_class>:<object_id>>'
                       else
                         '#<CukeModeler::<model_class>:<object_id> <some_meaningful_attribute>: <attribute_value>>'
                       end

    output           = @output[clazz][:output]
    expected_pattern = expected_pattern.sub('<model_class>', clazz.to_s.match(/CukeModeler::(.*)/)[1])
                                       .sub('<object_id>', '\d+')
                                       .sub('<some_meaningful_attribute>', '@\w+')
                                       .sub('<attribute_value>', '.*')

    expect(output).to match(expected_pattern), "#{clazz} did not provide the custom inspection output"
  end
end

Then(/^the default Ruby inspection is used$/) do
  @available_model_classes.each do |clazz|
    default_method = clazz.ancestors.find { |ancestor| ancestor.name == 'Object' }.instance_method(:inspect)

    output         = @output[clazz][:output]
    default_output = default_method.bind(@output[clazz][:model]).call

    expect(output).to eq(default_output), "#{clazz} did not provide the default inspection output"
  end
end

Then(/^the model returns models for the following steps:$/) do |step_names|
  step_names = step_names.raw.flatten

  expect(@result.map(&:text)).to eq(step_names)
end

Then(/^the model returns models for the following rows:$/) do |rows|
  rows = rows.raw

  expect(@result.collect { |row_model| row_model.cells.map(&:value) }).to eq(rows)
end

Then(/^the model returns a model for the following feature:$/) do |feature_name|
  feature_name = feature_name.raw.flatten.first

  expect(@result.name).to eq(feature_name)
end

Then(/^the model returns a model for the following table:$/) do |table_rows|
  table_rows = table_rows.raw

  expect(@result.rows.collect { |row| row.cells.map(&:value) }).to eq(table_rows)
end

Then(/^the model returns a model for the following doc string:$/) do |string_text|
  expect(@result.content).to eq(string_text)
end

Then(/^the model returns a model for the background "([^"]*)"$/) do |background_name|
  expect(@result.name).to eq(background_name)
end

Then(/^the model returns models for the following (?:rule|scenario|outline|tag|example)s:$/) do |model_names|
  model_names = model_names.raw.flatten

  expect(@result.map(&:name)).to eq(model_names)
end

Then(/^the model returns models for the following cells:$/) do |model_values|
  model_values = model_values.raw.flatten

  expect(@result.map(&:value)).to eq(model_values)
end

Then(/^all of them are equivalent$/) do
  expect(@results).to_not include(false)
end

But(/^none of the models are equivalent with a model for the following scenario:$/) do |gherkin_text|
  model = CukeModeler::Scenario.new(gherkin_text)

  @models.each do |other_model|
    expect(model == other_model).to_not be true
  end
end

But(/^none of the models are equivalent with a model for the following step:$/) do |gherkin_text|
  model = CukeModeler::Step.new(gherkin_text)

  @models.each do |other_model|
    expect(model == other_model).to_not be true
  end
end

Then(/^the model returns models for the following comments:$/) do |model_values|
  model_values = model_values.raw.flatten

  expect(@result.map(&:text)).to eq(model_values)
end
