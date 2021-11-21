require_relative '../../../../../environments/rspec_env'

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

  it 'has a source column' do
    expect(model).to respond_to(:source_column)
  end

  it 'can change its source column' do
    expect(model).to respond_to(:source_column=)

    model.source_column = :some_source_column
    expect(model.source_column).to eq(:some_source_column)
    model.source_column = :some_other_source_column
    expect(model.source_column).to eq(:some_other_source_column)
  end

  describe 'abstract instantiation' do

    context 'a new sourced object' do

      let(:model) { clazz.new }


      it 'starts with no source line' do
        expect(model.source_line).to be_nil
      end

      it 'starts with no source column' do
        expect(model.source_column).to be_nil
      end

    end

  end

end
