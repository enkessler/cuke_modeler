source 'http://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec


gherkin_major_version = 11

# Only versions of Cucumber that rely on the old `gherkin3` gem can be used
# with versions of the `cucumber-gherkin` gem for which there was never a cucumber release
if [9, 11, 12].include?(gherkin_major_version)
  gem 'cucumber', '2.2.0'
else
  gem 'cucumber', '>=4.0.0.rc.4' # The minimum version of Cucumber that uses the `cucumber-gherkin` gem
end

gem 'cucumber-gherkin', "~> #{gherkin_major_version}.0"
