Given /^that there are "([^"]*)" detailing models$/ do |spec_file|
  sub_directory = spec_file =~ /integration/ ? 'integration' : 'unit'
  spec_file = "#{@spec_directory}/#{sub_directory}/#{spec_file}"

  fail "The spec file does not exist: #{spec_file}" unless File.exists?(spec_file)

  @spec_file = spec_file
end

When /^the corresponding specifications are run$/ do
  command = "rspec #{@spec_file}"

  @specs_passed = system(command)
end

Then /^all of those specifications are met$/ do
  fail "There were unmet specifications in '#{@spec_file}'." unless @specs_passed
end
