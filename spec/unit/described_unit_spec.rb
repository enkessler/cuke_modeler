require 'spec_helper'

SimpleCov.command_name('Described') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Described, Unit' do

  let(:nodule) { CukeModeler::Described }
  let(:described_element) { Object.new.extend(nodule) }


  it 'has a description' do
    expect(described_element).to respond_to(:description)
    expect(described_element).to respond_to(:description_text)
  end

  it 'can change its description' do
    expect(described_element).to respond_to(:description=)
    expect(described_element).to respond_to(:description_text=)

    described_element.description = :some_description
    expect(described_element.description).to eq(:some_description)
    described_element.description = :some_other_description
    expect(described_element.description).to eq(:some_other_description)

    described_element.description_text = :some_description
    expect(described_element.description_text).to eq(:some_description)
    described_element.description_text = :some_other_description
    expect(described_element.description_text).to eq(:some_other_description)
  end

end
