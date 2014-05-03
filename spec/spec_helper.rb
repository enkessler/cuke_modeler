require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


require "#{File.dirname(__FILE__)}/../lib/cuke_modeler"


require "#{File.dirname(__FILE__)}/unit/bare_bones_unit_specs"
require "#{File.dirname(__FILE__)}/unit/prepopulated_unit_specs"
require "#{File.dirname(__FILE__)}/unit/nested_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/containing_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/modeled_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/named_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/described_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/sourced_element_unit_specs"
require "#{File.dirname(__FILE__)}/unit/tagged_element_unit_specs"


RSpec.configure do |config|
  config.before(:all) do
    @default_file_directory = "#{File.dirname(__FILE__)}/temp_files"
    @default_feature_file_name = 'test_feature.feature'
  end

  config.before(:each) do
    FileUtils.mkdir(@default_file_directory)
  end

  config.after(:each) do
    FileUtils.remove_dir(@default_file_directory, true)
  end
end
