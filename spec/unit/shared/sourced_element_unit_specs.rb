require 'spec_helper'

shared_examples_for 'a sourced element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has a source line' do
    expect(element).to respond_to(:source_line)
  end

  it 'can change its source line' do
    expect(element).to respond_to(:source_line=)

    element.source_line = :some_source_line
    expect(element.source_line).to eq(:some_source_line)
    element.source_line = :some_other_source_line
    expect(element.source_line).to eq(:some_other_source_line)
  end


  describe 'abstract instantiation' do

    context 'a new sourced object' do

      let(:element) { clazz.new }


      it 'starts with no source line' do
        expect(element.source_line).to be_nil
      end

    end

  end

end
