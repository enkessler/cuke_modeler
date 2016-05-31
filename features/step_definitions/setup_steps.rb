Given /^the following(?: feature)? file(?: "([^"]*)")?:$/ do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  File.open("#{@test_directory}/#{file_name}", 'w') { |file|
    file.write(file_text)
  }
end

When /^the file(?: "([^"]*)")? is read$/ do |file_name|
  @parsed_files ||= []
  @test_directory ||= @default_file_directory
  file_name ||= @default_feature_file_name

  @parsed_files << CukeModeler::FeatureFile.new("#{@test_directory}/#{file_name}")
end

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

When /^the directory(?: "([^"]*)")? is read$/ do |directory_name|
  @parsed_directories ||= []
  @test_directory = "#{@default_file_directory}/#{directory_name}" if directory_name

  @parsed_directories << CukeModeler::Directory.new(@test_directory)
end

When /^the following step definition file(?: "([^"]*)")?:$/ do |file_name, file_text|
  @test_directory ||= @default_file_directory
  file_name ||= @default_step_file_name

  File.open("#{@test_directory}/#{file_name}", 'w') { |file|
    file.write(file_text)
  }
end
