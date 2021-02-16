require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a parsed model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'can access its original parsing data' do
    expect(model).to respond_to(:parsing_data)
  end

  it 'can change its parsing data' do
    expect(model).to respond_to(:parsing_data=)

    model.parsing_data = :some_parsing_data
    expect(model.parsing_data).to eq(:some_parsing_data)
    model.parsing_data = :some_other_parsing_data
    expect(model.parsing_data).to eq(:some_other_parsing_data)
  end


  describe 'abstract instantiation' do

    context 'a new parsed object' do

      let(:model) { clazz.new }


      it 'starts with no parsing data' do
        expect(model.parsing_data).to be_nil
      end

    end

  end

end
