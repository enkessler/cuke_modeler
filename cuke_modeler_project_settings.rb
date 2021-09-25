ENV['MOST_CURRENT_GHERKIN_VERSION'] ||= '22'

ENV['CUKE_MODELER_REPORT_FOLDER'] ||= "#{__dir__}/reports"
ENV['CUKE_MODELER_RSPEC_REPORT_NAME'] ||= 'rspec_report'
ENV['CUKE_MODELER_RSPEC_REPORT_HTML_FILE'] ||= "#{ENV['CUKE_MODELER_RSPEC_REPORT_NAME']}.html"
ENV['CUKE_MODELER_CUCUMBER_REPORT_NAME'] ||= 'cucumber_report'
ENV['CUKE_MODELER_CUCUMBER_REPORT_HTML_FILE'] ||= "#{ENV['CUKE_MODELER_CUCUMBER_REPORT_NAME']}.html"
