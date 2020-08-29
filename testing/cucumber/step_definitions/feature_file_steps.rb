Given(/^a feature file model based on "([^"]*)"$/) do |file_name|
  file_path = "#{@root_test_directory}/#{file_name}"
  File.open(file_path, 'w') { |file| file.puts 'Feature:' } unless File.exist?(file_path)

  @model = CukeModeler::FeatureFile.new(file_path)
end

And(/^a feature file model based on that file$/) do |code_text|
  code_text = code_text.gsub('<file_path>', "'#{@file_path}'")

  eval(code_text)
end

And(/^the comment model of that feature file model$/) do |code_text|
  eval(code_text)
end
