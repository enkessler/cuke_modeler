Then /^(?:the )?file(?: "([^"]*)")? is found to have the following properties:$/ do |file, properties|
  file ||= 1
  properties = properties.rows_hash

  properties.each do |property, expected_value|
    if property == 'path'
      expected_value.sub!('path_to', @test_directory)
    end

    expected = expected_value
    actual = @parsed_files[file - 1].send(property.to_sym).to_s

    assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
  end
end

When /^(?:the )?file(?: "([^"]*)")? features are as follows:$/ do |file, feature|
  file ||= 1

  expected = feature.raw.flatten.first
  actual = @parsed_files[file - 1].feature.name

  assert(actual == expected, "Expected: #{expected}\n but was: #{actual}")
end

When /^(?:the )?file(?: "([^"]*)")? has no feature$/ do |file|
  file ||= 1

  assert @parsed_files[file - 1].feature.nil?
end

Then(/^the feature file has convenient output$/) do
  @parsed_files.first.method(:to_s).owner.should == CukeModeler::FeatureFile
end

Given(/^a feature file element based on "([^"]*)"$/) do |file_name|
  file_path = "#{@default_file_directory}/#{file_name}"
  File.open(file_path, 'w') { |file| file.puts "Feature:" } unless File.exists?(file_path)

  @model = CukeModeler::FeatureFile.new(file_path)
end
