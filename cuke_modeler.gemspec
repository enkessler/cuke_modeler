# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cuke_modeler/version'

Gem::Specification.new do |spec|
  spec.name          = "cuke_modeler"
  spec.version       = CukeModeler::VERSION
  spec.authors       = ["Eric Kessler"]
  spec.email         = ["morrow748@gmail.com"]
  spec.summary       = %q{A gem providing functionality to model a Cucumber test suite.}
  spec.homepage      = 'https://github.com/enkessler/cuke_modeler'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'gherkin', '< 3.0.0'
  spec.add_runtime_dependency('json', '~> 1.0')
  spec.add_runtime_dependency('multi_json', '~> 1.0')

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'rspec', '~> 2.14.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'racatt', '~> 1.0'
  spec.add_development_dependency 'coveralls'
end
