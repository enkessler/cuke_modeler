require 'spec_helper'

shared_examples_for 'a stringifiable model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'can provide a custom string representation of itself' do
    expect(model.method(:to_s).owner).to equal(clazz), "#{clazz} does not override #to_s"
  end

  it 'represents itself with as a string' do
    expect(model.to_s).to be_a(String)
  end

end
