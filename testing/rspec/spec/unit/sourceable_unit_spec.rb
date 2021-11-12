require_relative '../../../../environments/rspec_env'


RSpec.describe 'Sourceable, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Sourceable }
  let(:model) { Object.new.extend(nodule) }


  describe 'unique behavior' do

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

  end

end
