require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Taggable, Integration' do

  let(:nodule) { CukeModeler::Taggable }
  let(:model) { Object.new.extend(nodule).extend(CukeModeler::Nested) }


  describe 'unique behavior' do

    it 'inherits its applied tags from its ancestors' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      parent = double(all_tags: all_parent_tags)

      model.parent_model = parent

      expect(model.applied_tags).to eq(all_parent_tags)
    end

    it 'knows all of its applicable tags' do
      all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
      own_tags = [:tag_1, :tag_2]

      parent = double(all_tags: all_parent_tags)

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
