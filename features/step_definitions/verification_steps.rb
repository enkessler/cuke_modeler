Then(/^the "([^"]*)" of directory "([^"]*)" is "([^"]*)"$/) do |property, partial_directory_path, value|
  @directories[partial_directory_path].send(property).should == value.sub('path_to', @default_file_directory)
end

Then(/^directory "([^"]*)" contains the following feature files:$/) do |partial_directory_path, feature_files|
  contained_files = @directories[partial_directory_path].feature_files.collect { |feature_file| feature_file.name }

  contained_files.should =~ feature_files.raw.flatten
end

When(/^directory "([^"]*)" contains no feature files$/) do |partial_directory_path|
  @directories[partial_directory_path].feature_files.should be_empty
end

Then(/^directory "([^"]*)" contains the following directories:$/) do |partial_directory_path, directories|
  contained_directories = @directories[partial_directory_path].directories.collect { |directory| directory.name }

  contained_directories.should =~ directories.raw.flatten
end

When(/^directory "([^"]*)" contains no directories$/) do |partial_directory_path|
  @directories[partial_directory_path].directories.should be_empty
end

Then(/^all of them can be output as text$/) do
  @available_models.each do |model|
    raise("#{model}#to_s does not return a String") unless model.new.to_s.is_a?(String)
  end
end

And(/^this text is specifically formatted$/) do
  @available_models.each do |model|
    raise("#{model} does not override #to_s") unless model.instance_method(:to_s).owner == model
  end
end

Then(/^the following text is provided:$/) do |expected_text|
  expected_text.sub!('path_to', @default_file_directory)

  @output.should == expected_text
end

When(/^the output produces an equivalent element model when consumed$/) do
  @element_class.new(@output).to_s.should == @output
end

Then(/^the "([^"]*)" of feature file "([^"]*)" is "([^"]*)"$/) do |property, partial_file_path, value|
  @feature_file_models[partial_file_path].send(property).should == value.sub('path_to', @default_file_directory)
end

Then(/^feature file "([^"]*)" contains the feature "([^"]*)"$/) do |partial_file_path, feature_name|
  @feature_file_models[partial_file_path].feature.name.should == feature_name
end

When(/^feature file "([^"]*)" contains no feature$/) do |partial_file_path|
  @feature_file_models[partial_file_path].feature.should be_nil
end

Then(/^the "([^"]*)" of feature "([^"]*)" is "([^"]*)"$/) do |property, feature_name, value|
  @feature_models[feature_name].send(property).should == value
end

Then(/^all of them can be contained inside of another model$/) do
  @available_models.each do |model|
    raise("Expected #{model} to define :parent_element") unless model.method_defined?(:parent_element)
  end
end

And(/^all of them can contain other models$/) do
  @available_models.each do |model|
    raise("Expected #{model} to define :contains") unless model.method_defined?(:contains)
  end
end
