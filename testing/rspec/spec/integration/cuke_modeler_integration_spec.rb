require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'the gem' do

  it 'is compatible with the most recent version of `cucumber-gherkin`' do
    output = `bundle outdated`
    out_of_date_line = output.split("\n").find { |line| line =~ /cucumber-gherkin/ }

    expect(output).to_not include('cucumber-gherkin'), "Expected to be up to date but found '#{out_of_date_line}'"
  end

end
