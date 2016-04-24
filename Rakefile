require "bundler/gem_tasks"
require 'coveralls/rake/task'

require 'racatt'


namespace 'cuke_modeler' do

  task :clear_coverage do
    code_coverage_directory = "#{File.dirname(__FILE__)}/coverage"

    FileUtils.remove_dir(code_coverage_directory, true)
  end


  Racatt.create_tasks

  # Redefining the task from 'racatt' in order to clear the code coverage results
  task :test_everything => :clear_coverage


  # The task that CI will use
  Coveralls::RakeTask.new
  task :ci_build => [:smart_test, 'coveralls:push']

  desc 'Test gem based on Ruby/dependency versions'
  task :smart_test do |t, args|
    rspec_args = ''

    case
      when Gem.loaded_specs['gherkin'].version.version[/^4/]
        cucumber_args = '-t ~@gherkin -t ~@gherkin3'
      when Gem.loaded_specs['gherkin'].version.version[/^3/]
        cucumber_args = '-t ~@gherkin -t ~@gherkin4'
      else
        cucumber_args = '-t ~@gherkin3 -t ~@gherkin4'
    end

    cucumber_args += ' -f progress'

    Rake::Task['cuke_modeler:test_everything'].invoke(rspec_args, cucumber_args)
  end

end


task :default => 'cuke_modeler:smart_test'
