require 'bundler/gem_tasks'
require 'rake'
require 'racatt'
require 'coveralls/rake/task'
require 'rainbow'
require 'rubocop/rake_task'


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

    raise Rainbow('Parts of the gem are undocumented').red unless output =~ /100.00% documented/

    puts Rainbow('All code documented').green
  end

  desc 'Run all of the tests'
  task :test_everything => [:clear_coverage] do # rubocop:disable Style/HashSyntax
    rspec_args = '--tag ~@wip --pattern "testing/rspec/spec/**/*_spec.rb" --force-color'

    cucumber_version = Gem.loaded_specs['cucumber'].version.version
    cucumber_major_version = cucumber_version.match(/^(\d+)\./)[1].to_i

    # Command lines are long things
    # rubocop:disable Layout/LineLength
    if cucumber_major_version < 4
      cucumber_args = 'testing/cucumber/features -r testing/cucumber/support -r testing/cucumber/step_definitions -f progress -t ~@wip --color'
    else
      cucumber_args = "testing/cucumber/features -r testing/cucumber/support -r testing/cucumber/step_definitions -f progress -t 'not @wip' --color"
    end
    # rubocop:enable Layout/LineLength

    Rake::Task['racatt:test_everything'].invoke(rspec_args, cucumber_args)
  end

  # creates coveralls:push task
  Coveralls::RakeTask.new

  desc 'The task that CI will run. Do not run locally.'
  task :ci_build => ['cuke_modeler:test_everything', 'coveralls:push'] # rubocop:disable Style/HashSyntax

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

  desc 'Generate a Rubocop report for the project'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns   = ['./']
    task.formatters = ['fuubar', ['html', '--out', 'rubocop.html']]
    task.options    = ['-S']
  end

end


task :default => ['cuke_modeler:test_everything', 'cuke_modeler:rubocop'] # rubocop:disable Style/HashSyntax
