require 'spec_helper'

shared_examples_for 'a nested element' do

  # clazz must be defined by the calling file

  let(:nested_element) { clazz.new }


  it 'has a parent element' do
    expect(nested_element).to respond_to(:parent_element)
  end

  it 'can change its parent element' do
    expect(nested_element).to respond_to(:parent_element=)

    nested_element.parent_element = :some_parent_element
    expect(nested_element.parent_element).to eq(:some_parent_element)
    nested_element.parent_element = :some_other_parent_element
    expect(nested_element.parent_element).to eq(:some_other_parent_element)
  end

  it 'starts with no parent element' do
    expect(nested_element.parent_element).to be_nil
  end

  it 'has access to its ancestors' do
    expect(nested_element).to respond_to(:get_ancestor)
  end

  it 'gets an ancestor based on type' do
    expect(clazz.instance_method(:get_ancestor).arity).to eq(1)
  end

  it 'raises and exception if an unknown ancestor type is requested' do
    expect { nested_element.get_ancestor(:bad_ancestor_type) }.to raise_exception(ArgumentError)
  end

end
