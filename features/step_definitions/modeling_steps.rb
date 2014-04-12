When(/^the directory "([^"]*)" is modeled$/) do |partial_directory_path|
  @directories ||= {}

  @directories[partial_directory_path] = CukeModeler::Directory.new("#{@default_file_directory}/#{partial_directory_path}")
end

Given(/^the element models provided by CukeModeler/) do
  @available_models = Array.new.tap do |classes|
    CukeModeler.constants.each do |constant|
      classes << CukeModeler.const_get(constant) if CukeModeler.const_get(constant).is_a?(Class)
    end
  end
end

Given(/^a directory element based on "([^"]*)"$/) do |directory_name|
  directory_path = "#{@default_file_directory}/#{directory_name}"
  FileUtils.mkpath(directory_path) unless File.exists?(directory_path)

  @element = CukeModeler::Directory.new(directory_path)
  @element_class = @element.class
end

When(/^the file "([^"]*)" is modeled$/) do |partial_file_path|
  @feature_file_models ||= {}
  file_path = "#{@default_file_directory}/#{partial_file_path}"

  @feature_file_models[partial_file_path] = CukeModeler::FeatureFile.new(file_path)
end

Given(/^a feature file element based on "([^"]*)"$/) do |partial_file_path|
  file_path = "#{@default_file_directory}/#{partial_file_path}"
  FileUtils.touch(file_path)

  @element = CukeModeler::FeatureFile.new(file_path)
  @element_class = @element.class
end

Given(/^the following feature "([^"]*)":$/) do |feature_name, source_text|
  @feature_source ||= {}

  @feature_source[feature_name] = source_text
end

When(/^the feature "([^"]*)" is modeled$/) do |feature_name|
  @feature_models ||= {}

  source = @feature_source[feature_name]
  @feature_models[feature_name] = CukeModeler::Feature.new(source)
end
