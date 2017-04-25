unless RUBY_VERSION.to_s < '1.9.0'
  require 'simplecov'
  SimpleCov.command_name('rspec_tests')
end


# Ruby 1.8.x seems to have trouble if relative paths get too nested, so resolving the path before using it here
this_dir = File.expand_path(File.dirname(__FILE__))
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
require "#{this_dir}/unit/shared/keyworded_models_unit_specs"

require "#{this_dir}/../../dialect_helper"


# Use a fake dialect for testing in order to avoid hard coded language assumptions in the
# implementation. Only possible with newer versions of Gherkin.
if Gem.loaded_specs['gherkin'].version.version[/^2\./]
  CukeModeler::DialectHelper.set_dialect(Gherkin::I18n::LANGUAGES['en'])
  CukeModeler::Parsing.dialect = 'en'
else
  dialect_file_path = "#{this_dir}/../../test_languages.json"
  test_dialects = JSON.parse File.open(dialect_file_path, 'r:UTF-8').read

  Gherkin::DIALECTS.merge!(test_dialects)


  # Making the test dialect the default dialect so that language headers aren't
  # needed for all of the test code.
  module Gherkin
    class Parser

      alias_method :original_parse, :parse

      def parse(token_scanner, token_matcher = TokenMatcher.new('cm-test'))
        original_parse(token_scanner, token_matcher)
      end

    end
  end

  CukeModeler::DialectHelper.set_dialect(test_dialects['cm-test'])
  CukeModeler::Parsing.dialect = 'cm-test'
end


RSpec.configure do |config|
  case Gem.loaded_specs['gherkin'].version.version
    when /^4\./
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin3 => true,
                                  :gherkin4 => false
    when /^3\./
      config.filter_run_excluding :gherkin2 => true,
                                  :gherkin3 => false,
                                  :gherkin4 => true
    else
      config.filter_run_excluding :gherkin2 => false,
                                  :gherkin3 => true,
                                  :gherkin4 => true
  end

  config.before(:all) do
    @feature_keyword = CukeModeler::DialectHelper.feature_keyword
    @background_keyword = CukeModeler::DialectHelper.background_keyword
    @scenario_keyword = CukeModeler::DialectHelper.scenario_keyword
    @outline_keyword = CukeModeler::DialectHelper.outline_keyword
    @example_keyword = CukeModeler::DialectHelper.example_keyword
    @step_keyword = CukeModeler::DialectHelper.step_keyword
    @given_keyword = CukeModeler::DialectHelper.given_keyword
    @then_keyword = CukeModeler::DialectHelper.then_keyword

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
