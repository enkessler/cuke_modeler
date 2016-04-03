require 'spec_helper'

shared_examples_for 'a bare bones element' do

  # clazz must be defined by the calling file

  before(:each) do
    @element = clazz.new
  end

  it 'can be initialized empty' do
    expect { clazz.new }.to_not raise_error
  end

end
