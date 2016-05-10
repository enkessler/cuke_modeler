require 'spec_helper'

SimpleCov.command_name('Named') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Named, Unit' do

  let(:nodule) { CukeModeler::Named }
  let(:named_element) { Object.new.extend(nodule) }


  it 'has a name' do
    expect(named_element).to respond_to(:name)
  end

  it 'can change its name' do
    expect(named_element).to respond_to(:name=)

    named_element.name = :some_name
    expect(named_element.name).to eq(:some_name)
    named_element.name = :some_other_name
    expect(named_element.name).to eq(:some_other_name)
  end

end
