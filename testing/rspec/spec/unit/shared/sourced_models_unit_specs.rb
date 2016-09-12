require "#{File.dirname(__FILE__)}/../../spec_helper"

shared_examples_for 'a sourced model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has a source line' do
    expect(model).to respond_to(:source_line)
  end

  it 'can change its source line' do
    expect(model).to respond_to(:source_line=)

    model.source_line = :some_source_line
    expect(model.source_line).to eq(:some_source_line)
    model.source_line = :some_other_source_line
    expect(model.source_line).to eq(:some_other_source_line)
  end


  describe 'abstract instantiation' do

    context 'a new sourced object' do

      let(:model) { clazz.new }


      it 'starts with no source line' do
        expect(model.source_line).to be_nil
      end

    end

  end

end
