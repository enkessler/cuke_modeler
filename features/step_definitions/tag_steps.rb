Then /^the feature tag correctly stores its underlying implementation$/ do
  raw_element = @parsed_files.first.feature.tags.first.raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    raw_element.has_key?(:name).should be_true
  else
    raw_element.has_key?('name').should be_true
  end
end

When(/^the test tag correctly stores its underlying implementation$/) do
  raw_element = @parsed_files.first.feature.tests.first.tags.first.raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    raw_element.has_key?(:name).should be_true
  else
    raw_element.has_key?('name').should be_true
  end
end

When(/^the example tag correctly stores its underlying implementation$/) do
  raw_element = @parsed_files.first.feature.tests.first.examples.first.tags.first.raw_element

  if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
    raw_element.has_key?(:name).should be_true
  else
    raw_element.has_key?('name').should be_true
  end
end

Then(/^the feature tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tags.first

  tag.name.should == tag_name
end

When(/^the test tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tests.first.tags.first

  tag.name.should == tag_name
end

When(/^the example tag name is "([^"]*)"$/) do |tag_name|
  tag = @parsed_files.first.feature.tests.first.examples.first.tags.first

  tag.name.should == tag_name
end

Then(/^the feature tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tags.first

  tag.source_line.should == line
end

When(/^the test tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tests.first.tags.first

  tag.source_line.should == line
end

When(/^the example tag source line "([^"]*)"$/) do |line|
  tag = @parsed_files.first.feature.tests.first.examples.first.tags.first

  tag.source_line.should == line
end

Then(/^the tag has convenient output$/) do
  @parsed_files.first.feature.tags.first.method(:to_s).owner.should == CukeModeler::Tag
end

Given(/^a tag element based on the following gherkin:$/) do |tag_text|
  @model = CukeModeler::Tag.new(tag_text)
end

When(/^the scenario's (?:tags|inherited tags) are requested$/) do |code_text|
  @result = eval(code_text)
end

When(/^all of the scenarios tags are requested$/) do |code_text|
  @result = eval(code_text)
end
