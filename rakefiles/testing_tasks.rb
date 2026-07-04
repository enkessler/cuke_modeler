namespace 'cuke_modeler' do # rubocop:disable Metrics/BlockLength -- Namespaces inherently have a lot of lines

  desc 'Run all of the RSpec tests'
  task :run_rspec_tests => [:clear_old_results] do # rubocop:disable Style/HashSyntax
    puts Rainbow('Running RSpec tests...').cyan
    completed_process = CukeModeler::CukeModelerHelper.run_command(['bundle', 'exec', 'rspec',
                                                                    '--pattern', 'testing/rspec/spec/**/*_spec.rb'])

    raise(Rainbow('RSpec tests encountered problems!').red) unless completed_process.exit_code.zero?

    puts Rainbow('All RSpec tests passing.').green
  end

  desc 'Run all of the Cucumber tests'
  task :run_cucumber_tests => [:clear_old_results] do # rubocop:disable Style/HashSyntax
    current_version = CukeModeler::CukeModelerHelper.major_version_of('cucumber-gherkin')
    unsupported_versions = ENV['GHERKIN_MAJOR_VERSIONS_WITHOUT_CUCUMBER_SUPPORT'].split(',').map(&:to_i)

    # The `cucumber` gem does not support all major versions of the `cucumber-gherkin` gem. The Cucumber tests
    # cannot be run in those cases.
    if unsupported_versions.include?(current_version)
      puts Rainbow("Skipping Cucumber tests for unsupported Gherkin version #{current_version}...").cyan
    else
      puts Rainbow('Running Cucumber tests...').cyan
      completed_process = CukeModeler::CukeModelerHelper.run_command(%w[bundle exec cucumber])

      raise(Rainbow('Cucumber tests encountered problems!').red) unless completed_process.exit_code.zero?

      puts Rainbow('All Cucumber tests passing.').green
    end
  end

  desc 'Run all of the tests'
  task :test_everything => [:clear_old_results] do # rubocop:disable Style/HashSyntax
    puts Rainbow('Running tests...').cyan

    Rake::Task['cuke_modeler:run_rspec_tests'].invoke
    Rake::Task['cuke_modeler:run_cucumber_tests'].invoke

    puts Rainbow('All tests passing!').green
  end

end
