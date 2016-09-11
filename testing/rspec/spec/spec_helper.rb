unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('rspec_tests')
end


this_dir = File.dirname(__FILE__)

require "#{this_dir}/../../../lib/cuke_modeler"

require "#{this_dir}/unit/shared/models_unit_specs"
require "#{this_dir}/integration/shared/models_integration_specs"
require "#{this_dir}/unit/shared/named_models_unit_specs"
require "#{this_dir}/unit/shared/described_models_unit_specs"
require "#{this_dir}/unit/shared/stepped_models_unit_specs"
require "#{this_dir}/unit/shared/stringifiable_models_unit_specs"
require "#{this_dir}/unit/shared/nested_models_unit_specs"
require "#{this_dir}/unit/shared/tagged_models_unit_specs"
require "#{this_dir}/unit/shared/containing_models_unit_specs"
require "#{this_dir}/unit/shared/bare_bones_models_unit_specs"
require "#{this_dir}/unit/shared/prepopulated_models_unit_specs"
require "#{this_dir}/unit/shared/sourced_models_unit_specs"
require "#{this_dir}/unit/shared/parsed_models_unit_specs"


RSpec.configure do |config|
  case
    when Gem.loaded_specs['gherkin'].version.version[/^4/]
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin3 => true,
                                  :gherkin4 => false
    when Gem.loaded_specs['gherkin'].version.version[/^3/]
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin3 => false,
                                  :gherkin4 => true
    else
      config.filter_run_excluding :gherkin2 => false,
                                  :gherkin3 => true,
                                  :gherkin4 => true
  end

  config.before(:all) do
    @default_file_directory = "#{this_dir}/temp_files"
    @default_feature_file_name = 'test_feature.feature'
  end

  config.before(:each) do |spec|
    unless spec.metadata[:unit_test]
      FileUtils.remove_dir(@default_file_directory, true) if File.exists?(@default_file_directory)

      FileUtils.mkdir(@default_file_directory)
    end
  end

  config.after(:each) do |spec|
    unless spec.metadata[:unit_test]
      FileUtils.remove_dir(@default_file_directory, true)
    end
  end

end
