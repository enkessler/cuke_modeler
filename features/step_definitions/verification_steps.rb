Then(/^all of them can be output as text appropriate to the model type$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect(clazz.instance_method(:to_s).owner).to equal(clazz), "#{clazz} does not override #to_s"

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the following text is provided:$/) do |expected_text|
  expected_text.sub!('<path_to>', @default_file_directory)

  @output.should == expected_text
end

Then(/^all of them can be contained inside of another model$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect { eval(code_text) }.to_not raise_error
  end
end

And(/^all of them can contain other models$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^all of them can be created without further context$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the model returns "([^"]*)"$/) do |value|
  value.gsub!('path_to', @default_file_directory) if value.is_a?(String)

  expect(@result).to eq(value)
end

Then(/^the model returns$/) do |value|
  value.gsub!('path_to', @default_file_directory) if value.is_a?(String)

  expect(@result).to eq(value)
end

Then(/^the model returns models for the following feature files:$/) do |file_names|
  file_names = file_names.raw.flatten

  expect(@result.collect { |file_model| file_model.name }).to match_array(file_names)
end

Then(/^the model returns models for the following directories:$/) do |directory_names|
  directory_names = directory_names.raw.flatten

  expect(@result.collect { |directory_model| directory_model.name }).to match_array(directory_names)
end

And(/^the output can be used to make an equivalent model$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^all of them provide access to the parsing data that was used to create them$/) do |code_text|
  unparsed_models = [CukeModeler::ModelElement, CukeModeler::FeatureFile, CukeModeler::Directory]

  @available_model_classes.each do |clazz|
    next if unparsed_models.include?(clazz)

    code_text.gsub!('<model_class>', clazz.to_s)
    code_text.gsub!('<source_text>', '')

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the model returns models for the following steps:$/) do |step_names|
  step_names = step_names.raw.flatten

  expect(@result.collect { |step_model| step_model.base }).to eq(step_names)
end

Then(/^the model returns models for the following rows:$/) do |rows|
  rows = rows.raw

  expect(@result.collect { |row_model| row_model.cells }).to eq(rows)
end

Then(/^the model returns a model for the following feature:$/) do |feature_name|
  feature_name = feature_name.raw.flatten.first

  expect(@result.name).to eq(feature_name)
end

Then(/^the model returns the following values:$/) do |cell_values|
  cell_values = cell_values.raw.flatten

  expect(@result).to eq(cell_values)
end

Then(/^the model returns a model for the following table:$/) do |table_rows|
  table_rows = table_rows.raw

  expect(@result.rows.collect { |row| row.cells }).to eq(table_rows)
end

Then(/^the model returns a model for the following doc string:$/) do |string_text|
  expect(@result.contents).to eq(string_text)
end

Then(/^the model returns a model for the background "([^"]*)"$/) do |background_name|
  expect(@result.name).to eq(background_name)
end

Then(/^the model returns models for the following (?:scenario|outline|tag)s:$/) do |model_names|
  model_names = model_names.raw.flatten

  expect(@result.collect { |model| model.name }).to eq(model_names)
end
