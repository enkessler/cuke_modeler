require 'spec_helper'

shared_examples_for 'a nested element' do

  # clazz must be defined by the calling file

  let(:nested_element) { clazz.new }


  it 'has a parent model' do
    expect(nested_element).to respond_to(:parent_model)
  end

  it 'can change its parent model' do
    expect(nested_element).to respond_to(:parent_model=)

    nested_element.parent_model = :some_parent_model
    expect(nested_element.parent_model).to eq(:some_parent_model)
    nested_element.parent_model = :some_other_parent_model
    expect(nested_element.parent_model).to eq(:some_other_parent_model)
  end


  describe 'abstract instantiation' do

    context 'a new nested object' do

      let(:nested_element) { clazz.new }


      it 'starts with no parent model' do
        expect(nested_element.parent_model).to be_nil
      end

    end

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
