namespace 'cuke_modeler' do # rubocop:disable Metrics/BlockLength - Namespaces inherently have a lot of lines

  desc 'Generate a Rubocop report for the project'
  task :rubocop do
    puts Rainbow('Checking for code style violations...').cyan

    completed_process = CukeModeler::CukeModelerHelper.run_command(['bundle', 'exec', 'rubocop',
                                                                    '--format', 'fuubar',
                                                                    '--format', 'html', '--out', "#{ENV['CUKE_MODELER_REPORT_FOLDER']}/rubocop.html", # rubocop:disable Layout/LineLength
                                                                    '-S', '-D'])

    raise(Rainbow('RuboCop found violations').red) unless completed_process.exit_code.zero?

    puts Rainbow('RuboCop is pleased.').green
  end

  desc 'Check for outdated dependencies'
  task :check_dependencies do
    puts Rainbow('Checking for out of date dependencies...').cyan
    completed_process = CukeModeler::CukeModelerHelper.run_command(['bundle', 'outdated',
                                                                    'cucumber-gherkin',
                                                                    '--filter-major'])

    raise Rainbow('Some dependencies are out of date').red unless completed_process.exit_code.zero?

    puts Rainbow('All dependencies up to date').green
  end

  desc 'Check pretty much everything'
  task :full_check do
    puts Rainbow('Performing full check...').cyan

    Rake::Task['cuke_modeler:test_everything'].invoke
    Rake::Task['cuke_modeler:check_documentation'].invoke
    Rake::Task['cuke_modeler:rubocop'].invoke

    puts Rainbow('All is well. :)').green
  end

end
