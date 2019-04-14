# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_modeler/version'

Gem::Specification.new do |spec|
  spec.name          = "cuke_modeler"
  spec.version       = CukeModeler::VERSION
  spec.authors       = ["Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]
  spec.summary       = %q{A gem providing functionality to model Gherkin based test suites.}
  spec.description   = %q{This gem facilitates modeling a test suite that is written in Gherkin (e.g. Cucumber, SpecFlow, Lettuce, etc.). It does this by providing an abstraction layer on top of the Abstract Syntax Tree that the 'gherkin' gem generates when parsing features, as well as providing models for feature files and directories in order to be able to have a fully traversable model tree of a test suite's structure. These models can then be analyzed or manipulated more easily than the underlying AST layer.}
  spec.homepage      = 'https://github.com/enkessler/cuke_modeler'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.8.7', '< 3.0'

  spec.add_runtime_dependency 'gherkin', '< 7.0'
  spec.add_runtime_dependency('json', '>= 1.0', '< 3.0')
  spec.add_runtime_dependency('multi_json', '~> 1.0')

  spec.add_development_dependency 'bundler', '< 3.0'
  spec.add_development_dependency "rake", '< 13.0.0'
  spec.add_development_dependency 'cucumber', '< 5.0.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '< 1.0.0'
  spec.add_development_dependency 'racatt', '~> 1.0'
  spec.add_development_dependency 'coveralls', '< 1.0.0'
end
