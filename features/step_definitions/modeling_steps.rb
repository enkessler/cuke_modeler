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
