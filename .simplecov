require 'simplecov-lcov'

SimpleCov.command_name(ENV.fetch('CUKE_MODELER_SIMPLECOV_COMMAND_NAME'))


SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.lcov_file_name = 'lcov.info'
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter,
                                                                SimpleCov::Formatter::LcovFormatter])

SimpleCov.start do
  root __dir__
  coverage_dir "#{ENV.fetch('CUKE_MODELER_REPORT_FOLDER')}/coverage"

  add_filter '/testing/'
  add_filter '/environments/'
  add_filter 'cuke_modeler_helper'

  merge_timeout 300
end
