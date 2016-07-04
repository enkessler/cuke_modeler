require 'spec_helper'

SimpleCov.command_name('Nested') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Nested, Unit' do

  let(:nodule) { CukeModeler::Nested }
  let(:nested_element) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    describe 'an object including the module' do

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

      it 'has access to its ancestors' do
        nested_element.should respond_to(:get_ancestor)
      end

      it 'gets an ancestor based on type' do
        (nodule.instance_method(:get_ancestor).arity == 1).should be_true
      end

      it 'raises and exception if an unknown ancestor type is requested' do
        expect { nested_element.get_ancestor(:bad_ancestor_type) }.to raise_exception(ArgumentError)
      end

    end

  end

end
