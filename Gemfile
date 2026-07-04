source 'http://rubygems.org'

# Specify your gem's dependencies in cuke_modeler.gemspec
gemspec

require_relative 'cuke_modeler_project_settings'

gherkin_major_version_used = 41
gherkin_major_versions_without_cucumber_support = ENV['GHERKIN_MAJOR_VERSIONS_WITHOUT_CUCUMBER_SUPPORT'].split(',')
                                                                                                        .map(&:to_i)

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

if RUBY_VERSION =~ /^4\./
  # base64 gem stopped being included automatically after Ruby 3.4
  gem 'base64' if gherkin_major_version_used == 27 # rubocop:disable Gemspec/DevelopmentDependencies
  # win32ole gem stopped being included automatically after Ruby 4.0
  gem 'win32ole' if RbConfig::CONFIG['host_os'].downcase =~ /mswin|msys|mingw32/ # rubocop:disable Gemspec/DevelopmentDependencies
end

gem 'cucumber-gherkin', "~> #{gherkin_major_version_used}.0"
