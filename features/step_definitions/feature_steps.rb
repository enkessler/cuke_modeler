Then /^(?:the )?feature(?: "([^"]*)")? is found to have the following properties:$/ do |file, properties|
  file ||= 1
  properties = properties.rows_hash

  properties.each do |property, expected_value|
    expected = expected_value
    actual = @parsed_files[file - 1].feature.send(property.to_sym).to_s

    assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
  end
end

Then /^(?:the )?feature "([^"]*)" has the following description:$/ do |file, text|
  new_description = @parsed_files[file - 1].feature.description_text
  old_description = @parsed_files[file - 1].feature.description

  new_description.should == text
  old_description.should == remove_whitespace(text)
end

Then /^feature "([^"]*)" is found to have the following tags:$/ do |file, expected_tags|
  expected_tags = expected_tags.raw.flatten

  @parsed_files[file - 1].feature.tags.should == expected_tags
  @parsed_files[file - 1].feature.tag_elements.collect { |tag| tag.name }.should == expected_tags
end

Then /^feature "([^"]*)" has no description$/ do |file|
  @parsed_files[file - 1].feature.description_text.should == ''
  @parsed_files[file - 1].feature.description.should == []
end

Then /^feature "([^"]*)" has no tags$/ do |file|
  assert @parsed_files[file - 1].feature.tags == []
  assert @parsed_files[file - 1].feature.tag_elements.collect { |tag| tag.name } == []
end

When /^(?:the )?feature(?: "([^"]*)")? scenarios are as follows:$/ do |file, scenarios|
  file ||= 1

  actual_scenarios = @parsed_files[file - 1].feature.scenarios.collect { |scenario| scenario.name }

  assert actual_scenarios.flatten.sort == scenarios.raw.flatten.sort
end

When /^(?:the )?feature(?: "([^"]*)")? outlines are as follows:$/ do |file, outlines|
  file ||= 1

  actual_outlines = @parsed_files[file - 1].feature.outlines.collect { |outline| outline.name }

  expected = outlines.raw.flatten.sort
  actual = actual_outlines.flatten.sort

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^(?:the )?feature(?: "([^"]*)")? background is as follows:$/ do |file, background|
  file ||= 1

  @parsed_files[file - 1].feature.background.name.should == background.raw.flatten.first
end

When /^feature "([^"]*)" has no scenarios$/ do |file|
  assert @parsed_files[file - 1].feature.scenarios == []
end

When /^feature "([^"]*)" has no outlines/ do |file|
  assert @parsed_files[file - 1].feature.outlines == []
end

When /^feature "([^"]*)" has no background/ do |file|
  assert @parsed_files[file - 1].feature.has_background? == false
end

Then /^(?:the )?feature(?: "([^"]*)")? correctly stores its underlying implementation$/ do |file|
  file ||= 1

  raw_element = @parsed_files[file - 1].feature.raw_element

  raw_element.has_key?('elements').should be_true
end

Then(/^the feature has convenient output$/) do
  @parsed_files.first.feature.method(:to_s).owner.should == CukeModeler::Feature
end

Given(/^a feature element based on the following gherkin:$/) do |feature_text|
  @element = CukeModeler::Feature.new(feature_text)
end

def remove_whitespace(text)
  stripped_text = text.split("\n").collect { |line| line.strip }
  stripped_text.delete('')

  stripped_text
end
