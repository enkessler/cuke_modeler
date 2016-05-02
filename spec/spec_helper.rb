require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


this_dir = File.dirname(__FILE__)

require "#{this_dir}/../lib/cuke_modeler"

require "#{this_dir}/unit/feature_element_unit_specs"
require "#{this_dir}/unit/nested_element_unit_specs"
require "#{this_dir}/unit/tagged_element_unit_specs"
require "#{this_dir}/unit/containing_element_unit_specs"
require "#{this_dir}/unit/bare_bones_unit_specs"
require "#{this_dir}/unit/test_element_unit_specs"
require "#{this_dir}/unit/prepopulated_unit_specs"
require "#{this_dir}/unit/sourced_element_unit_specs"
require "#{this_dir}/unit/raw_element_unit_specs"


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
    @default_file_directory = "#{this_dir}/temp_files"
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

