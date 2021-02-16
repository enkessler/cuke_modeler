SimpleCov.command_name(ENV['CUKE_MODELER_SIMPLECOV_COMMAND_NAME'])

SimpleCov.start do
  root __dir__
  coverage_dir "#{ENV['CUKE_MODELER_REPORT_FOLDER']}/coverage"

  add_filter '/testing/'
  add_filter '/environments/'
  add_filter 'cuke_modeler_helper'

  merge_timeout 300
end
