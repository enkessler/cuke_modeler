require_relative '../../../../environments/rspec_env'


RSpec.describe 'Described, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Described }
  let(:described_model) { Object.new.extend(nodule) }


  it 'has a description' do
    expect(described_model).to respond_to(:description)
  end

  it 'can change its description' do
    expect(described_model).to respond_to(:description=)

    described_model.description = :some_description
    expect(described_model.description).to eq(:some_description)
    described_model.description = :some_other_description
    expect(described_model.description).to eq(:some_other_description)
  end

end
