namespace 'cuke_modeler' do

  desc 'The task that CI will run. Do not run locally.'
  task :ci_build => ['cuke_modeler:full_check'] # rubocop:disable Style/HashSyntax

end
