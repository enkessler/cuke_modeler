require 'spec_helper'


describe 'Taggable, Unit' do

  let(:nodule) { CukeModeler::Taggable }
  let(:model) { o = Object.new.extend(nodule)

                  def o.parent_model
                    @parent_model
                  end

                  def o.parent_model=(parent)
                    @parent_model = parent
                  end

                  o
                }


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

    it 'inherits its applied tags from its ancestors' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      parent = double(:all_tags => all_parent_tags)

      model.parent_model = parent

      expect(model.applied_tags).to eq(all_parent_tags)
    end

    it 'knows all of its applicable tags' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      own_tags = [:tag_1, :tag_2]

      parent = double(:all_tags => all_parent_tags)

      model.parent_model = parent
      model.tags = own_tags

      expect(model.all_tags).to eq(all_parent_tags + own_tags)
    end

    it 'may have no applied tags' do
      model.parent_model = :not_a_tagged_object

      expect(model.applied_tags).to eq([])
    end

  end

end
