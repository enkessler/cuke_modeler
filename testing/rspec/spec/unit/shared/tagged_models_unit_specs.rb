require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a tagged model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


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


  describe 'abstract instantiation' do

    context 'a new tagged object' do

      let(:model) { clazz.new }


      it 'starts with no tags' do
        expect(model.tags).to eq([])
      end

      it 'starts with no inherited tags' do
        expect(model.applied_tags).to eq([])
      end

      it 'starts with no tags at all' do
        expect(model.all_tags).to eq([])
      end

    end

  end

  it 'has applied tags' do
    expect(model).to respond_to(:applied_tags)
  end

  it 'inherits its applied tags from its ancestors' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    parent = double(all_tags: all_parent_tags)

    model.parent_model = parent

    expect(model.applied_tags).to match_array(all_parent_tags)
  end

  it 'knows all of its applicable tags' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    own_tags = [:tag_1, :tag_2]

    parent = double(all_tags: all_parent_tags)

    model.parent_model = parent
    model.tags = own_tags

    expect(model.all_tags).to match_array(all_parent_tags + own_tags)
  end

end
