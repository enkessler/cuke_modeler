require 'spec_helper'

shared_examples_for 'a tagged element' do |clazz|

  before(:each) do
    @element = clazz.new
  end


  it 'has tags' do
    @element.should respond_to(:tags)
  end

  it 'can change its tags' do
    @element.should respond_to(:tags=)

    @element.tags = :some_tags
    @element.tags.should == :some_tags
    @element.tags = :some_other_tags
    @element.tags.should == :some_other_tags
  end

  it 'starts with no tags' do
    @element.tags.should == []
  end

end
