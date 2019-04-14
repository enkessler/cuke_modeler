require "bundler/gem_tasks"
require 'rake'
require 'racatt'
require 'coveralls/rake/task'
require 'rainbow'


Rainbow.enabled = true

namespace 'racatt' do
  Racatt.create_tasks
end


namespace 'cuke_modeler' do

  desc 'Removes the current code coverage data'
  task :clear_coverage do
    code_coverage_directory = "#{File.dirname(__FILE__)}/coverage"

    FileUtils.remove_dir(code_coverage_directory, true)
  end

  desc 'Check documentation with RDoc'
  task :check_documentation do
    output = `rdoc lib -C`
    puts output

    if output =~ /100.00% documented/
      puts Rainbow('All code documented').green
    else
      raise Rainbow('Parts of the gem are undocumented').red
    end
  end

  desc 'Run all of the tests'
  task :test_everything => [:clear_coverage] do
    rspec_args = '--tag ~@wip --pattern "testing/rspec/spec/**/*_spec.rb" --force-color'

    cucumber_version = Gem.loaded_specs['cucumber'].version.version

    if cucumber_version =~ /^[123]\./
      cucumber_args = 'testing/cucumber/features -r testing/cucumber/support -r testing/cucumber/step_definitions -f progress -t ~@wip --color'
    else
      cucumber_args = "testing/cucumber/features -r testing/cucumber/support -r testing/cucumber/step_definitions -f progress -t 'not @wip' --color"
    end

    Rake::Task['racatt:test_everything'].invoke(rspec_args, cucumber_args)
  end

  # creates coveralls:push task
  Coveralls::RakeTask.new

  desc 'The task that CI will run. Do not run locally.'
  task :ci_build => ['cuke_modeler:test_everything', 'coveralls:push']

  desc 'Check that things look good before trying to release'
  task :prerelease_check do
    begin
      Rake::Task['cuke_modeler:test_everything'].invoke
      Rake::Task['cuke_modeler:check_documentation'].invoke
    rescue => e
      puts Rainbow("Something isn't right!").red
      raise e
    end

    puts Rainbow('All is well. :)').green
  end

  # TODO: stop using Relish
  # The task used to publish the current feature file documentation to Relish
  desc 'Publish feature files to Relish'
  task :publish_features do
    # Get existing versions
    this_dir = File.dirname(__FILE__)
    output = `relish versions enkessler/CukeModeler`

    # Add the current version if it doesn't exist
    unless output =~ /#{Regexp.escape(CukeModeler::VERSION)}/
      output = `relish versions:add enkessler/CukeModeler:#{CukeModeler::VERSION}`
      puts output
    end

    # Publish the features
    output = `relish push enkessler/CukeModeler:#{CukeModeler::VERSION} path #{this_dir}/testing/cucumber`
    puts output
  end

end


task :default => 'cuke_modeler:test_everything'
