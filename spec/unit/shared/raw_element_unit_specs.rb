require 'spec_helper'

shared_examples_for 'a parsed element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'can access its original parsing data' do
    expect(element).to respond_to(:parsing_data)
  end

  it 'can change its parsing data' do
    expect(element).to respond_to(:parsing_data=)

    element.parsing_data = :some_parsing_data
    expect(element.parsing_data).to eq(:some_parsing_data)
    element.parsing_data = :some_other_parsing_data
    expect(element.parsing_data).to eq(:some_other_parsing_data)
  end


  describe 'abstract instantiation' do

    context 'a new parsed object' do

      let(:element) { clazz.new }


      it 'starts with no parsing data' do
        expect(element.parsing_data).to be_nil
      end

    end

  end

end
