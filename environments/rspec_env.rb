ENV['CUKE_MODELER_SIMPLECOV_COMMAND_NAME'] ||= 'rspec_tests'

require 'simplecov'
require_relative 'common_env'


require_relative '../testing/rspec/spec/unit/shared/models_unit_specs'
require_relative '../testing/rspec/spec/integration/shared/models_integration_specs'
require_relative '../testing/rspec/spec/unit/shared/named_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/described_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/stepped_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/stringifiable_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/nested_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/tagged_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/containing_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/bare_bones_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/prepopulated_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/sourced_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/parsed_models_unit_specs'
require_relative '../testing/rspec/spec/unit/shared/keyworded_models_unit_specs'

require_relative '../testing/dialect_helper'
require_relative '../testing/helper_methods'
require_relative '../testing/model_factory'

require 'rubygems/mock_gem_ui'


# Use a random dialect for testing in order to avoid hard coded language assumptions in the
# implementation.

# TODO: choose randomly from Gherkin::DIALECTS once I figure out how to handle encodings...
# But never use 'en-au' because there are tests that assume that that's not the current language
test_dialect = %w[en en-lol en-pirate en-Scouse].sample
puts "Testing with dialect '#{test_dialect}'..."

CukeModeler::DialectHelper.dialect = Gherkin::DIALECTS[test_dialect]
CukeModeler::Parsing.dialect = test_dialect

# Making the test dialect the default dialect so that language headers
# aren't needed for all of the test code.
module Gherkin
  class << self

    alias original_from_source from_source

    def from_source(uri, data, options = {})
      options[:default_dialect] ||= CukeModeler::Parsing.dialect
      original_from_source(uri, data, options)
    end

  end
end


RSpec.configure do |config|

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    FEATURE_KEYWORD = CukeModeler::DialectHelper.feature_keyword
    BACKGROUND_KEYWORD = CukeModeler::DialectHelper.background_keyword
    RULE_KEYWORD = CukeModeler::DialectHelper.rule_keyword
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

  # Methods will be available outside of tests
  include CukeModeler::HelperMethods

  # Methods will be available inside of tests
  config.include CukeModeler::ModelFactory
end
