lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_modeler/version'

Gem::Specification.new do |spec|
  spec.name          = 'cuke_modeler'
  spec.version       = CukeModeler::VERSION
  spec.authors       = ['Eric Kessler']
  spec.email         = ['morrow748@gmail.com']
  spec.summary       = 'A gem providing functionality to model Gherkin based test suites.'
  spec.description   = ['This gem facilitates modeling a test suite that is written in Gherkin (e.g. Cucumber, ',
                        'SpecFlow, Lettuce, etc.). It does this by providing an abstraction layer on top of the ',
                        "Abstract Syntax Tree that the 'cucumber-gherkin' gem generates when parsing features, ",
                        'as well as providing models for feature files and directories in order to be able to ',
                        "have a fully traversable model tree of a test suite's structure. These models can then ",
                        'be analyzed or manipulated more easily than the underlying AST layer.'].join
  spec.homepage      = 'https://github.com/enkessler/cuke_modeler'
  spec.license       = 'MIT'

  spec.metadata = {
    'bug_tracker_uri'       => 'https://github.com/enkessler/cuke_modeler/issues',
    'changelog_uri'         => 'https://github.com/enkessler/cuke_modeler/blob/master/CHANGELOG.md',
    'documentation_uri'     => 'https://www.rubydoc.info/gems/cuke_modeler',
    'homepage_uri'          => 'https://github.com/enkessler/cuke_modeler',
    'source_code_uri'       => 'https://github.com/enkessler/cuke_modeler',
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('', __dir__)) do
    source_controlled_files = `git ls-files -z`.split("\x0")
    source_controlled_files.keep_if { |file| file =~ %r{^(lib|testing/cucumber/features)} }
    source_controlled_files + ['README.md', 'LICENSE.txt', 'CHANGELOG.md', 'cuke_modeler.gemspec']
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3', '< 4.0'

  spec.add_runtime_dependency 'cucumber-gherkin', '< 27.0'

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'childprocess', '< 5.0'
  spec.add_development_dependency 'ffi', '< 2.0' # This is an invisible dependency for the `childprocess` gem on Windows
  # Cucumber 4.x is the earliest version to use cucumber-gherkin
  spec.add_development_dependency 'cucumber', '>= 4.0.0', '< 8.0.0'
  spec.add_development_dependency 'rainbow', '< 4.0.0'
  spec.add_development_dependency 'rake', '< 14.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  # Running recent RuboCop versions requires a recent version of Ruby but it can still lint against Ruby 2.3 styles
  spec.add_development_dependency 'rubocop', '< 2.0'
  spec.add_development_dependency 'simplecov', '< 1.0'
  spec.add_development_dependency 'simplecov-lcov', '< 1.0'
  spec.add_development_dependency 'test-unit', '< 4.0.0'
  spec.add_development_dependency 'yard', '< 1.0'
end
