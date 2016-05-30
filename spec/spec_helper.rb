require 'simplecov' unless RUBY_VERSION.to_s < '1.9.0'


this_dir = File.dirname(__FILE__)

require "#{this_dir}/../lib/cuke_modeler"

require "#{this_dir}/unit/shared/modeled_element_unit_specs"
require "#{this_dir}/integration/shared/modeled_element_integration_specs"
require "#{this_dir}/unit/shared/named_element_unit_specs"
require "#{this_dir}/unit/shared/described_element_unit_specs"
require "#{this_dir}/unit/shared/stepped_element_unit_specs"
require "#{this_dir}/unit/shared/stringifiable_unit_specs"
require "#{this_dir}/unit/shared/nested_element_unit_specs"
require "#{this_dir}/unit/shared/tagged_element_unit_specs"
require "#{this_dir}/unit/shared/containing_element_unit_specs"
require "#{this_dir}/unit/shared/bare_bones_unit_specs"
require "#{this_dir}/unit/shared/prepopulated_unit_specs"
require "#{this_dir}/unit/shared/sourced_element_unit_specs"
require "#{this_dir}/unit/shared/raw_element_unit_specs"


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

