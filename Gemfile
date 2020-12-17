source 'http://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec


gherkin_major_version = 16

# Only versions of Cucumber that rely on the old `gherkin3` gem can be used
# with versions of the `cucumber-gherkin` gem for which there was never a cucumber release
unsupported_gherkin_versions = [9, 11, 12, 16]

# rubocop:disable Bundler/DuplicatedGem
if unsupported_gherkin_versions.include?(gherkin_major_version)
  gem 'cucumber', '2.2.0'
elsif gherkin_major_version == 13
  # Prerelease versions are not usually used but it's the only version of Cucumber that supports Gherkin 13
  gem 'cucumber', '>4.0.0.rc.4'
end
# rubocop:enable Bundler/DuplicatedGem

gem 'cucumber-gherkin', "~> #{gherkin_major_version}.0"
