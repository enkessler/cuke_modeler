source 'http://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec


gherkin_major_version_used = 20
gherkin_major_versions_without_cucumber_support = [9, 11, 12, 16, 17, 19]

# rubocop:disable Bundler/DuplicatedGem
if RUBY_VERSION =~ /^2\.[34]/
  gem 'activesupport', '< 6.0' # Requires Ruby 2.5 at this version
  gem 'parallel', '< 1.20' # Requires Ruby 2.5 at this version

  if (gherkin_major_versions_without_cucumber_support + [15]).include?(gherkin_major_version_used)
    gem 'cucumber', '2.2.0' # No recent version of cucumber that supports this Ruby & cucumber-gherkin combination
  else
    gem 'cucumber', '>=4.0.0.rc.4', '< 5.0' # Requires Ruby 2.5 at this version
  end
elsif gherkin_major_versions_without_cucumber_support.include?(gherkin_major_version_used)
  gem 'cucumber', '2.2.0' # No recent version of cucumber that supports this Ruby & cucumber-gherkin combination
else
  gem 'cucumber', '>=4.0.0.rc.4' # The minimum version of Cucumber that uses the `cucumber-gherkin` gem
end
# rubocop:enable Bundler/DuplicatedGem

gem 'cucumber-gherkin', "~> #{gherkin_major_version_used}.0"
