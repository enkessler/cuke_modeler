require 'spec_helper'

shared_examples_for 'a tagged element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has tags' do
    expect(element).to respond_to(:tags)
  end

  it 'can get and set its tags' do
    expect(element).to respond_to(:tags=)

    element.tags = :some_tags
    expect(element.tags).to eq(:some_tags)
    element.tags = :some_other_tags
    expect(element.tags).to eq(:some_other_tags)
  end

  it 'starts with no tags' do
    expect(element.tags).to eq([])
  end

  it 'has applied tags' do
    expect(element).to respond_to(:applied_tags)
  end

  it 'inherits its applied tags from its ancestors' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    parent = double(:all_tags => all_parent_tags)

    element.parent_element = parent

    expect(element.applied_tags).to match_array(all_parent_tags)
  end

  it 'knows all of its applicable tags' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    own_tags = [:tag_1, :tag_2]

    parent = double(:all_tags => all_parent_tags)

    element.parent_element = parent
    element.tags = own_tags

    expect(element.all_tags).to match_array(all_parent_tags + own_tags)
  end

end
