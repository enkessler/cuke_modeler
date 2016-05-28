Then(/^all of them can be output as text appropriate to the model type$/) do |code_text|
  @available_model_classes.each do |clazz|
    code_text.gsub!('<model_class>', clazz.to_s)

    expect { eval(code_text) }.to_not raise_error
  end
end

Then(/^the following text is provided:$/) do |expected_text|
  expected_text.sub!('path_to', @default_file_directory)

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
