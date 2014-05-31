require 'spec_helper'

shared_examples_for 'a prepopulated element' do |clazz|

  before(:each) do
    @element = clazz.new
  end

  it 'can take an argument' do
    (clazz.instance_method(:initialize).arity != 0).should be_true
  end

end
