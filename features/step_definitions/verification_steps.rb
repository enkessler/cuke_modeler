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

Then(/^the text provided is "(.*)"$/) do |text_string|
  @output.should == text_string.gsub('\n', "\n")
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
  value.gsub!('path_to', @default_file_directory)

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
