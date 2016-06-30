Given(/^a feature file element based on "([^"]*)"$/) do |file_name|
  file_path = "#{@default_file_directory}/#{file_name}"
  File.open(file_path, 'w') { |file| file.puts "Feature:" } unless File.exists?(file_path)

  @model = CukeModeler::FeatureFile.new(file_path)
end
