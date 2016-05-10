require 'spec_helper'

SimpleCov.command_name('Stepped') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Stepped, Unit' do

  let(:nodule) { CukeModeler::Stepped }
  let(:stepped_element) { Object.new.extend(nodule) }


  it 'has steps' do
    expect(stepped_element).to respond_to(:steps)
  end

  it 'can change its steps' do
    expect(stepped_element).to respond_to(:steps=)

    stepped_element.steps = :some_steps
    expect(stepped_element.steps).to eq(:some_steps)
    stepped_element.steps = :some_other_steps
    expect(stepped_element.steps).to eq(:some_other_steps)
  end

end
