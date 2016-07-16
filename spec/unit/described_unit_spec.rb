require 'spec_helper'


describe 'Described, Unit' do

  let(:nodule) { CukeModeler::Described }
  let(:described_element) { Object.new.extend(nodule) }


  it 'has a description' do
    expect(described_element).to respond_to(:description)
  end

  it 'can change its description' do
    expect(described_element).to respond_to(:description=)

    described_element.description = :some_description
    expect(described_element.description).to eq(:some_description)
    described_element.description = :some_other_description
    expect(described_element.description).to eq(:some_other_description)
  end

end
