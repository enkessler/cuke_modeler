ENV['CUKE_MODELER_SIMPLECOV_COMMAND_NAME'] ||= 'cucumber_tests'

require 'simplecov'
require_relative 'common_env'

require_relative '../testing/cucumber/step_definitions/action_steps'
require_relative '../testing/cucumber/step_definitions/background_steps'
require_relative '../testing/cucumber/step_definitions/directory_steps'
require_relative '../testing/cucumber/step_definitions/doc_string_steps'
require_relative '../testing/cucumber/step_definitions/feature_file_steps'
require_relative '../testing/cucumber/step_definitions/feature_steps'
require_relative '../testing/cucumber/step_definitions/modeling_steps'
require_relative '../testing/cucumber/step_definitions/setup_steps'
require_relative '../testing/cucumber/step_definitions/step_steps'
require_relative '../testing/cucumber/step_definitions/table_steps'
require_relative '../testing/cucumber/step_definitions/tag_steps'
require_relative '../testing/cucumber/step_definitions/verification_steps'

require 'test/unit/assertions'
World(Test::Unit::Assertions)


Before do
  @root_test_directory = CukeModeler::FileHelper.create_directory
end

at_exit do
  CukeModeler::FileHelper.created_directories.each do |dir_path|
    FileUtils.remove_entry(dir_path, true)
  end
end
