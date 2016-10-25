require "#{File.dirname(__FILE__)}/../../spec_helper"


shared_examples_for 'a keyworded model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has a keyword' do
    expect(model).to respond_to(:keyword)
  end

  it 'can change its keyword' do
    expect(model).to respond_to(:keyword=)

    model.keyword = :some_keyword
    expect(model.keyword).to eq(:some_keyword)
    model.keyword = :some_other_keyword
    expect(model.keyword).to eq(:some_other_keyword)
  end


  describe 'abstract instantiation' do

    context 'a new object' do

      let(:model) { clazz.new }


      it 'starts with no keyword' do
        expect(model.keyword).to be_nil
      end

    end

  end


  describe 'model output' do

    context 'from abstract instantiation' do

      let(:model) { clazz.new }


      it 'can output a model that has only a keyword' do
        model.keyword = 'foo'

        expect { model.to_s }.to_not raise_error
      end

    end

  end

end
