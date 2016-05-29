require 'spec_helper'

shared_examples_for 'a named element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a name' do
    expect(element).to respond_to(:name)
  end

  it 'can change its name' do
    expect(element).to respond_to(:name=)

    element.name = :some_name
    expect(element.name).to eq(:some_name)
    element.name = :some_other_name
    expect(element.name).to eq(:some_other_name)
  end


  describe 'abstract instantiation' do

    context 'a new named object' do

      let(:element) { clazz.new }


      it 'starts with no name' do
        expect(element.name).to eq('')
      end

    end

  end

end
