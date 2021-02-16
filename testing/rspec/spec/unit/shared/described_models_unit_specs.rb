require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a described model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has a description' do
    expect(model).to respond_to(:description)
  end

  it 'can change its description' do
    expect(model).to respond_to(:description=)

    model.description = :some_description
    expect(model.description).to eq(:some_description)
    model.description = :some_other_description
    expect(model.description).to eq(:some_other_description)
  end


  describe 'abstract instantiation' do

    context 'a new described object' do

      let(:model) { clazz.new }

      it 'starts with no description' do
        expect(model.description).to be_nil
      end

    end

  end

end
