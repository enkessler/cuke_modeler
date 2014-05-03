require 'spec_helper'

SimpleCov.command_name('Taggable') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Taggable, Unit' do

  nodule = CukeModeler::Taggable

  before(:each) do
    @element = Object.new.extend(nodule)
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

end
