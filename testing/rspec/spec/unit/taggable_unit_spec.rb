require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Taggable, Unit', unit_test: true do

  let(:nodule) { CukeModeler::Taggable }
  let(:model) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    it 'has tags' do
      expect(model).to respond_to(:tags)
    end

    it 'can change its tags' do
      expect(model).to respond_to(:tags=)

      model.tags = :some_tags
      expect(model.tags).to eq(:some_tags)
      model.tags = :some_other_tags
      expect(model.tags).to eq(:some_other_tags)
    end

    it 'has applied tags' do
      expect(model).to respond_to(:applied_tags)
    end

  end

end
