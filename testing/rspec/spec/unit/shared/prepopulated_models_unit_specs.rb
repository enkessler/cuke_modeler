require "#{File.dirname(__FILE__)}/../../spec_helper"

shared_examples_for 'a prepopulated model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'can take text from which to populate itself' do
    expect(clazz.instance_method(:initialize).arity).to_not eq(0)
  end

  it 'will complain if given non-text input' do
    expect { clazz.new(:not_a_string) }.to raise_error(ArgumentError, 'Can only create models from Strings but was given a Symbol.')
  end

end
