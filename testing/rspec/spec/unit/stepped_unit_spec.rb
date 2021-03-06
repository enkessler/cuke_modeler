require_relative '../../../../environments/rspec_env'


RSpec.describe 'Stepped, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Stepped }
  let(:stepped_model) { Object.new.extend(nodule) }


  it 'has steps' do
    expect(stepped_model).to respond_to(:steps)
  end

  it 'can change its steps' do
    expect(stepped_model).to respond_to(:steps=)

    stepped_model.steps = :some_steps
    expect(stepped_model.steps).to eq(:some_steps)
    stepped_model.steps = :some_other_steps
    expect(stepped_model.steps).to eq(:some_other_steps)
  end

end
