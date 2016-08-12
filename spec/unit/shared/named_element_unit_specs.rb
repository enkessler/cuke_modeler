require 'spec_helper'

shared_examples_for 'a named model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has a name' do
    expect(model).to respond_to(:name)
  end

  it 'can change its name' do
    expect(model).to respond_to(:name=)

    model.name = :some_name
    expect(model.name).to eq(:some_name)
    model.name = :some_other_name
    expect(model.name).to eq(:some_other_name)
  end


  describe 'abstract instantiation' do

    context 'a new named object' do

      let(:model) { clazz.new }


      it 'starts with no name' do
        expect(model.name).to eq('')
      end

    end

  end

end
