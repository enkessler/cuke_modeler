source 'https://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec

# cuke_modeler can play with pretty much any version of these but they all play differently with Ruby
if RUBY_VERSION =~ /^1\.8/
  gem 'cucumber', '<1.3.0'
  gem 'gherkin', '<2.12.0'
  gem 'mime-types', '<2.0.0'
  gem 'rest-client', '<1.7.0'
elsif RUBY_VERSION =~ /^1\./
  gem 'cucumber', '<2.0.0'
elsif RUBY_VERSION =~ /^2\.[23456789]/
  gem 'test-unit'
end
