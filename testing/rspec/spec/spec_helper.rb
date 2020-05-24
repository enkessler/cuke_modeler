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
require "#{this_dir}/../../file_helper"
require "#{this_dir}/../../helper_methods"

require 'rubygems/mock_gem_ui'


# Use a random dialect for testing in order to avoid hard coded language assumptions in the
# implementation and making the test dialect the default dialect so that language headers
# aren't needed for all of the test code. Only possible with some versions of Gherkin.

gherkin_major_version = Gem.loaded_specs['gherkin'].version.version.match(/^(\d+)\./)[1].to_i

case gherkin_major_version
  when 6, 7
    # gherkin 6+ does not preload the dialect module
    require 'gherkin/dialect'

    # TODO: choose randomly from Gherkin::DIALECTS once I figure out how to handle encodings...
    test_dialect = ['en', 'en-lol', 'en-pirate', 'en-Scouse'].sample
    puts "Testing with dialect '#{test_dialect}'..."


    CukeModeler::DialectHelper.set_dialect(Gherkin::DIALECTS[test_dialect])
    CukeModeler::Parsing.dialect = test_dialect
  when 3, 4, 5
# TODO: stop using test dialect and just randomize for all version of `gherkin`
    dialect_file_path = "#{this_dir}/../../test_languages.json"
    test_dialects = JSON.parse File.open(dialect_file_path, 'r:UTF-8').read

    Gherkin::DIALECTS.merge!(test_dialects)


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
  when 2
    CukeModeler::DialectHelper.set_dialect(Gherkin::I18n::LANGUAGES['en'])
    CukeModeler::Parsing.dialect = 'en'
  else
    raise("Unknown Gherkin major version: '#{gherkin_major_version}'")
end


RSpec.configure do |config|

  include CukeModeler::HelperMethods

  config.before(:suite) do
    FEATURE_KEYWORD = CukeModeler::DialectHelper.feature_keyword
    BACKGROUND_KEYWORD = CukeModeler::DialectHelper.background_keyword
    SCENARIO_KEYWORD = CukeModeler::DialectHelper.scenario_keyword
    OUTLINE_KEYWORD = CukeModeler::DialectHelper.outline_keyword
    EXAMPLE_KEYWORD = CukeModeler::DialectHelper.example_keyword
    STEP_KEYWORD = CukeModeler::DialectHelper.step_keyword
    GIVEN_KEYWORD = CukeModeler::DialectHelper.given_keyword
    THEN_KEYWORD = CukeModeler::DialectHelper.then_keyword
  end

  config.after(:suite) do
    CukeModeler::FileHelper.created_directories.each do |dir_path|
      FileUtils.remove_entry(dir_path, true)
    end
  end

end
