source 'http://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec


gherkin_major_version = 17

# rubocop:disable Bundler/DuplicatedGem
if RUBY_VERSION =~ /^2\.[34]/
  gem 'activesupport', '< 6.0' # Requires Ruby 2.5 at this version
  gem 'parallel', '< 1.20' # Requires Ruby 2.5 at this version

  if [9, 11, 12, 15, 16, 17].include?(gherkin_major_version)
    gem 'cucumber', '2.2.0' # No recent version of cucumber that supports this Ruby & cucumber-gherkin combination
  else
    gem 'cucumber', '>=4.0.0.rc.4', '< 5.0' # Requires Ruby 2.5 at this version
  end
elsif [9, 11, 12, 16, 17].include?(gherkin_major_version)
  gem 'cucumber', '2.2.0' # No recent version of cucumber that supports this Ruby & cucumber-gherkin combination
else
  gem 'cucumber', '>=4.0.0.rc.4' # The minimum version of Cucumber that uses the `cucumber-gherkin` gem
end
# rubocop:enable Bundler/DuplicatedGem

gem 'cucumber-gherkin', "~> #{gherkin_major_version}.0"
