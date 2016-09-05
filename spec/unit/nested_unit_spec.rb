require 'spec_helper'


describe 'Nested, Unit', :unit_test => true do

  let(:nodule) { CukeModeler::Nested }
  let(:nested_model) { Object.new.extend(nodule) }


  describe 'unique behavior' do

    describe 'an object including the module' do

      it 'has a parent model' do
        expect(nested_model).to respond_to(:parent_model)
      end

      it 'can change its parent model' do
        expect(nested_model).to respond_to(:parent_model=)

        nested_model.parent_model = :some_parent_model
        expect(nested_model.parent_model).to eq(:some_parent_model)
        nested_model.parent_model = :some_other_parent_model
        expect(nested_model.parent_model).to eq(:some_other_parent_model)
      end

      it 'has access to its ancestors' do
        expect(nested_model).to respond_to(:get_ancestor)
      end

      it 'gets an ancestor based on type' do
        expect(nodule.instance_method(:get_ancestor).arity).to eq(1)
      end

      it 'raises and exception if an unknown ancestor type is requested' do
        expect { nested_model.get_ancestor(:bad_ancestor_type) }.to raise_exception(ArgumentError)
      end

    end

  end

end
