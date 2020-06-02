require 'simplecov'
SimpleCov.command_name('rspec_tests')


require_relative '../../../lib/cuke_modeler'

require_relative 'unit/shared/models_unit_specs'
require_relative 'integration/shared/models_integration_specs'
require_relative 'unit/shared/named_models_unit_specs'
require_relative 'unit/shared/described_models_unit_specs'
require_relative 'unit/shared/stepped_models_unit_specs'
require_relative 'unit/shared/stringifiable_models_unit_specs'
require_relative 'unit/shared/nested_models_unit_specs'
require_relative 'unit/shared/tagged_models_unit_specs'
require_relative 'unit/shared/containing_models_unit_specs'
require_relative 'unit/shared/bare_bones_models_unit_specs'
require_relative 'unit/shared/prepopulated_models_unit_specs'
require_relative 'unit/shared/sourced_models_unit_specs'
require_relative 'unit/shared/parsed_models_unit_specs'
require_relative 'unit/shared/keyworded_models_unit_specs'

require_relative '../../dialect_helper'
require_relative '../../file_helper'
require_relative '../../helper_methods'

require 'rubygems/mock_gem_ui'


# Use a random dialect for testing in order to avoid hard coded language assumptions in the
# implementation and making the test dialect the default dialect so that language headers
# aren't needed for all of the test code. Only possible with some versions of Gherkin.

gherkin_major_version = Gem.loaded_specs['cucumber-gherkin'].version.version.match(/^(\d+)\./)[1].to_i

case gherkin_major_version
  when 9, 10, 11, 12, 13
    # TODO: choose randomly from Gherkin::DIALECTS once I figure out how to handle encodings...
    test_dialect = ['en', 'en-lol', 'en-pirate', 'en-Scouse'].sample
    puts "Testing with dialect '#{test_dialect}'..."

    CukeModeler::DialectHelper.set_dialect(Gherkin::DIALECTS[test_dialect])
    CukeModeler::Parsing.dialect = test_dialect

    module Gherkin
      class << self
        alias_method :original_from_source, :from_source

        def from_source(uri, data, options = {})
          options[:default_dialect] ||= CukeModeler::Parsing.dialect
          original_from_source(uri, data, options)
        end
      end
    end
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
