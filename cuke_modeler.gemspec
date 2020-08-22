lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_modeler/version'

Gem::Specification.new do |spec|
  spec.name          = "cuke_modeler"
  spec.version       = CukeModeler::VERSION
  spec.authors       = ["Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]
  spec.summary       = 'A gem providing functionality to model Gherkin based test suites.'
  spec.description   = "This gem facilitates modeling a test suite that is written in Gherkin (e.g. Cucumber, SpecFlow, Lettuce, etc.). It does this by providing an abstraction layer on top of the Abstract Syntax Tree that the 'cucumber-gherkin' gem generates when parsing features, as well as providing models for feature files and directories in order to be able to have a fully traversable model tree of a test suite's structure. These models can then be analyzed or manipulated more easily than the underlying AST layer."
  spec.homepage      = 'https://github.com/enkessler/cuke_modeler'
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('', __dir__)) do
    source_controlled_files = `git ls-files -z`.split("\x0")
    source_controlled_files.keep_if { |file| file =~ %r{^(lib|testing/cucumber/features)} }
    source_controlled_files + ['README.md', 'LICENSE.txt', 'CHANGELOG.md', 'cuke_modeler.gemspec']
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3', '< 3.0'

  spec.add_runtime_dependency 'cucumber-gherkin', '< 16.0'

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency 'coveralls', '< 1.0.0'
  spec.add_development_dependency 'cucumber', '< 5.0.0'
  spec.add_development_dependency 'racatt', '~> 1.0'
  spec.add_development_dependency 'rainbow', '< 4.0.0'
  spec.add_development_dependency 'rake', '< 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '< 0.82.0'
  spec.add_development_dependency 'simplecov', '<= 0.16.1'
  spec.add_development_dependency 'test-unit', '< 4.0.0'
end
