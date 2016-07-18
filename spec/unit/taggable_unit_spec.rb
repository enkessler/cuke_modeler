require 'spec_helper'


describe 'Taggable, Unit' do

  let(:nodule) { CukeModeler::Taggable }
  let(:element) { o = Object.new.extend(nodule)

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
      expect(element).to respond_to(:tags)
    end

    it 'can change its tags' do
      expect(element).to respond_to(:tags=)

      element.tags = :some_tags
      expect(element.tags).to eq(:some_tags)
      element.tags = :some_other_tags
      expect(element.tags).to eq(:some_other_tags)
    end

    it 'has applied tags' do
      expect(element).to respond_to(:applied_tags)
    end

    it 'inherits its applied tags from its ancestors' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      parent = double(:all_tags => all_parent_tags)

      element.parent_model = parent

      expect(element.applied_tags).to eq(all_parent_tags)
    end

    it 'knows all of its applicable tags' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      own_tags = [:tag_1, :tag_2]

      parent = double(:all_tags => all_parent_tags)

      element.parent_model = parent
      element.tags = own_tags

      expect(element.all_tags).to eq(all_parent_tags + own_tags)
    end

    it 'may have no applied tags' do
      element.parent_model = :not_a_tagged_object

      expect(element.applied_tags).to eq([])
    end

  end

end
