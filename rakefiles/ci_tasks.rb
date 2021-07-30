namespace 'cuke_modeler' do

  desc 'The task that CI will run.'
  task :ci_build => ['cuke_modeler:full_check'] # rubocop:disable Style/HashSyntax

end
