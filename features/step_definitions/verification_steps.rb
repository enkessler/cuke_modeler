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

Then(/^the name of feature "([^"]*)" is "([^"]*)"$/) do |feature_name, value|
  @feature_models[feature_name].name.should == value
end

Then(/^feature "([^"]*)" has no name$/) do |feature_name|
  @feature_models[feature_name].name.should == ''
end

Then(/^the source line of feature "([^"]*)" is "([^"]*)"$/) do |feature_name, line|
  @feature_models[feature_name].source_line.should == line.to_i
end

Then(/^the source line of the first background is "([^"]*)"$/) do |line|
  @background_models.first.source_line.should == line.to_i
end

Then(/^the source line of the second background is "([^"]*)"$/) do |line|
  @background_models[1].source_line.should == line.to_i
end

Then(/^the feature "([^"]*)" has the following description:$/) do |feature_name, text|
  @feature_models[feature_name].description.should == text
end

Then(/^the first background has the following description:$/) do |text|
  @background_models.first.description.should == text
end

When(/^the feature "([^"]*)" has no description$/) do |feature_name|
  @feature_models[feature_name].description.should == ''
end

Then(/^the second background has no description$/) do
  @background_models[1].description.should be_empty
end

Then(/^the background of feature "([^"]*)" is "([^"]*)"$/) do |feature_name, background_name|
  background = @feature_models[feature_name].background

  background.name.should == background_name
end

And(/^feature "([^"]*)" has no background$/) do |feature_name|
  @feature_models[feature_name].background.should be_nil
end

Then(/^the feature "([^"]*)" has the following tags:$/) do |feature_name, tags|
  attached_tags = @feature_models[feature_name].tags.collect { |tag| tag.name }

  attached_tags.should =~ tags.raw.flatten
end

And(/^the feature "([^"]*)" has no tags$/) do |feature_name|
  @feature_models[feature_name].tags.should be_empty
end

Then(/^the feature "([^"]*)" has the following scenarios:$/) do |feature_name, scenarios|
  contained_scenarios = @feature_models[feature_name].scenarios.collect { |scenario| scenario.name }

  contained_scenarios.should =~ scenarios.raw.flatten
end

And(/^the feature "([^"]*)" has no scenarios/) do |feature_name|
  @feature_models[feature_name].scenarios.should be_empty
end

Then(/^the feature "([^"]*)" has the following outlines:$/) do |feature_name, outlines|
  contained_outlines = @feature_models[feature_name].outlines.collect { |outline| outline.name }

  contained_outlines.should =~ outlines.raw.flatten
end

And(/^the feature "([^"]*)" has no outlines/) do |feature_name|
  @feature_models[feature_name].outlines.should be_empty
end

Then(/^the feature tag name is "([^"]*)"$/) do |name|
  @feature_file_models[@default_file_name].feature.tags.first.name.should == name
end

Then(/^the first background's name is "([^"]*)"$/) do |name|
  @background_models.first.name.should == name
end

Then(/^the second background has no name$/) do
  @background_models[1].name.should be_empty
end

Then(/^the first scenario's name is "([^"]*)"$/) do |name|
  @feature_file_models[@default_file_name].feature.scenarios.first.name.should == name
end

Then(/^the second scenario has no name$/) do
  @feature_file_models[@default_file_name].feature.scenarios[1].name.should == ''
end

Then(/^the first outline's name is "([^"]*)"$/) do |name|
  @feature_file_models[@default_file_name].feature.outlines.first.name.should == name
end

Then(/^the second outline has no name$/) do
  @feature_file_models[@default_file_name].feature.outlines[1].name.should == ''
end

Then(/^the first background has the following steps:$/) do |steps|
  attached_steps = @background_models.first.steps.collect { |step| step.base }

  attached_steps.should =~ steps.raw.flatten
end

And(/^the second background has no steps$/) do
  @background_models[1].steps.should be_empty
end

Then(/^all of them can be contained inside of another model$/) do
  @available_models.each do |model|
    raise("Expected #{model} to define :parent_element") unless model.method_defined?(:parent_element)
    raise("Expected #{model} to define :parent_element") unless model.method_defined?(:get_ancestor)
  end
end

And(/^all of them can contain other models$/) do
  @available_models.each do |model|
    raise("Expected #{model} to define :contains") unless model.method_defined?(:contains)
  end
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

Then(/^the first steps's text is "([^"]*)"$/) do |text|
  @feature_file_models[@default_file_name].feature.background.steps.first.base.should == text
end

Then(/^the second steps's text is "([^"]*)"$/) do |text|
  @feature_file_models[@default_file_name].feature.background.steps[1].base.should == text
end

Then(/^the third steps's text is "([^"]*)"$/) do |text|
  @feature_file_models[@default_file_name].feature.background.steps[2].base.should == text
end

Then(/^the fourth steps's text is "([^"]*)"$/) do |text|
  @feature_file_models[@default_file_name].feature.background.steps[3].base.should == text
end
