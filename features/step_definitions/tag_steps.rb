Then /^the feature tag correctly stores its underlying implementation$/ do
  raw_element = @parsed_files.first.feature.tag_elements.first.raw_element

  raw_element.has_key?('name').should be_true
end

When(/^the test tag correctly stores its underlying implementation$/) do
  raw_element = @parsed_files.first.feature.tests.first.tag_elements.first.raw_element

  raw_element.has_key?('name').should be_true
end

When(/^the example tag correctly stores its underlying implementation$/) do
  raw_element = @parsed_files.first.feature.tests.first.examples.first.tag_elements.first.raw_element

  raw_element.has_key?('name').should be_true
end

Then(/^the feature tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tag_elements.first

  tag.name.should == tag_name
end

When(/^the test tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tests.first.tag_elements.first

  tag.name.should == tag_name
end

When(/^the example tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tests.first.examples.first.tag_elements.first

  tag.name.should == tag_name
end

Then(/^the feature tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tag_elements.first

  tag.source_line.should == line
end

When(/^the test tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tests.first.tag_elements.first

  tag.source_line.should == line
end

When(/^the example tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tests.first.examples.first.tag_elements.first

  tag.source_line.should == line
end

Then(/^the tag has convenient output$/) do
  @parsed_files.first.feature.tag_elements.first.method(:to_s).owner.should == CukeModeler::Tag
end

Given(/^a tag element based on the following gherkin:$/) do |tag_text|
  @element = CukeModeler::Tag.new(tag_text)
end
