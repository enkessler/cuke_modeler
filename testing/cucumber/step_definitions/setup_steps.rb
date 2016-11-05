Given /^(?:a|the) directory "([^"]*)"$/ do |directory_name|
  @test_directory = "#{@default_file_directory}/#{directory_name}"

  FileUtils.mkdir(@test_directory) unless File.exists?(@test_directory)
end

And(/^(?:a|the) file "([^"]*)"$/) do |file_name|
  file_path = "#{@default_file_directory}/#{file_name}"

  # Some versions of Gherkin require feature content to be present in feature files
  if file_name =~ /\.feature/
    File.open(file_path, 'w') { |file|
      file.write('Feature:')
    }
  else
    FileUtils.touch(file_path)
  end
end

And(/^the file "([^"]*)":$/) do |file_name, file_text|
  file_path = "#{@default_file_directory}/#{file_name}"

  File.open(file_path, 'w') { |file| file.write(file_text) }
end

Given(/^the following gherkin:$/) do |text|
  @source_text = text
end

Given(/^a feature file with the following gherkin:$/) do |file_text|
  @file_path = "#{@default_file_directory}/#{@default_feature_file_name}"

  File.open(@file_path, 'w') { |file| file.write(file_text) }
end
