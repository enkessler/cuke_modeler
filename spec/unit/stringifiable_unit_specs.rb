require 'spec_helper'

shared_examples_for 'a stringifiable element' do

  # clazz must be defined by the calling file

  let(:element) { clazz.new }


  it 'can provide a custom string representation of itself' do
    expect(element.method(:to_s).owner).to equal(clazz), "#{clazz} does not override #to_s"
  end

  it 'represents itself with as a string' do
    expect(element.to_s).to be_a(String)
  end

end
