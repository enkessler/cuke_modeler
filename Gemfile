source 'https://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec

# cuke_modeler can play with pretty much any version of these but they all play differently with Ruby

if RUBY_VERSION =~ /^1\./

  gem 'tins', '< 1.7' # The 'tins' gem requires Ruby 2.x on/after this version
  gem 'json', '< 2.0' # The 'json' gem drops pre-Ruby 2.x support on/after this version
  gem 'term-ansicolor', '< 1.4' # The 'term-ansicolor' gem requires Ruby 2.x on/after this version

  if RUBY_VERSION =~ /^1\.8/
    gem 'cucumber', '~> 1.0' # Ruby 1.8.x support dropped after this version
    gem 'gherkin', '< 2.12.1' # Ruby 1.8.x support dropped after this version
    gem 'rake', '< 11.0' # Ruby 1.8.x support dropped after this version
  end

elsif RUBY_VERSION =~ /^2\./

  if RUBY_VERSION =~ /^2\.[23456789]/
    gem 'test-unit'
  end

  gem 'gherkin', '~> 5.0'

end
