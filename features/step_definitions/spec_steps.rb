Given(/^that there are "([^"]*)" detailing models$/) do |file_name|
  sub_directory = file_name =~ /integration/ ? 'integration' : 'unit'
  @spec_file = "#{@spec_directory}/#{sub_directory}/#{file_name}"

  fail "The spec file does not exist: #{@spec_file}" unless File.exists?(@spec_file)
end

When(/^the those specifications are run$/) do
  command = "bundle exec rspec #{@spec_file}"

  @specs_passed = system(command)
end

Then(/^all of those specifications are met$/) do
  fail "There were unmet specifications in '#{@spec_file}'." unless @specs_passed
end
