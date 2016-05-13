require 'spec_helper'

shared_examples_for 'a tagged element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'has tags' do
    element.should respond_to(:tags)
  end

  it 'can get and set its tags' do
    expect(element).to respond_to(:tags=)

    element.tags = :some_tags
    element.tags.should == :some_tags
    element.tags = :some_other_tags
    element.tags.should == :some_other_tags
  end

  it 'starts with no tags' do
    element.tags.should == []
  end

  it 'has applied tags' do
    element.should respond_to(:applied_tags)
  end

  it 'inherits its applied tags from its ancestors' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    parent = double(:all_tags => all_parent_tags)

    element.parent_element = parent

    element.applied_tags.should == all_parent_tags
  end

  it 'knows all of its applicable tags' do
    all_parent_tags = [:parent_tag_1, :parent_tag_2, :grandparent_tag_1]
    own_tags = [:tag_1, :tag_2]

    parent = double(:all_tags => all_parent_tags)

    element.parent_element = parent
    element.tags = own_tags

    element.all_tags.should == all_parent_tags + own_tags
  end

end
