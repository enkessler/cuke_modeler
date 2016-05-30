require 'spec_helper'

shared_examples_for 'a prepopulated element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'can take an argument' do
    expect(clazz.instance_method(:initialize).arity).to_not eq(0)
  end

end
