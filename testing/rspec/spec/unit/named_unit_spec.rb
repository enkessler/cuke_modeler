require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Named, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Named }
  let(:named_model) { Object.new.extend(nodule) }


  it 'has a name' do
    expect(named_model).to respond_to(:name)
  end

  it 'can change its name' do
    expect(named_model).to respond_to(:name=)

    named_model.name = :some_name
    expect(named_model.name).to eq(:some_name)
    named_model.name = :some_other_name
    expect(named_model.name).to eq(:some_other_name)
  end

end
