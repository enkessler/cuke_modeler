require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


require "#{File.dirname(__FILE__)}/../lib/cuke_modeler"


RSpec.configure do |config|
  config.before(:all) do
    @default_file_directory = "#{File.dirname(__FILE__)}/temp_files"
  end

  config.before(:each) do
    FileUtils.mkdir(@default_file_directory)
  end

  config.after(:each) do
    FileUtils.remove_dir(@default_file_directory, true)
  end
end
