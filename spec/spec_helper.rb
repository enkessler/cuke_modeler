require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


require_relative '../lib/cuke_modeler'

require_relative 'unit/feature_element_unit_specs'
require_relative 'unit/nested_element_unit_specs'
require_relative 'unit/tagged_element_unit_specs'
require_relative 'unit/containing_element_unit_specs'
require_relative 'unit/bare_bones_unit_specs'
require_relative 'unit/test_element_unit_specs'
require_relative 'unit/prepopulated_unit_specs'
require_relative 'unit/sourced_element_unit_specs'
require_relative 'unit/raw_element_unit_specs'


RSpec.configure do |config|
  case
    when Gem.loaded_specs['gherkin'].version.version[/^4/]
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin3 => true
    when Gem.loaded_specs['gherkin'].version.version[/^3/]
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin4 => true
    else
      config.filter_run_excluding :gherkin3 => true,
                                  :gherkin4 => true
  end

  config.before(:all) do
    @default_file_directory = "#{File.dirname(__FILE__)}/temp_files"
    @default_feature_file_name = 'test_feature.feature'
  end

  config.before(:each) do
    FileUtils.remove_dir(@default_file_directory, true) if File.exists?(@default_file_directory)

    FileUtils.mkdir(@default_file_directory)
  end

  config.after(:each) do
    FileUtils.remove_dir(@default_file_directory, true)
  end
end

