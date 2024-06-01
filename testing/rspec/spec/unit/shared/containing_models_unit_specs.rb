require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a containing model' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  it 'has children' do
    expect(model).to respond_to(:children)
  end

  it 'returns a collection of children' do
    expect(model.children).to be_an(Array)
  end

  it 'does not return objects for children that it does not have' do
    # Ensuring an empty, childless model
    model = clazz.new

    expect(model.children).to_not include(nil)
  end


  describe 'tree traversal' do

    it 'is enumerable' do
      expect(model).to be_a(Enumerable)
      expect(model).to respond_to(:each)
    end

    it 'provides an Enumerator' do
      expect(model.each).to be_a(Enumerator)
    end


    context 'with children' do


      let(:root_model) do
        m = clazz.new
        m.extend(CukeModeler::ModelFactory)

        # Not all models have a name, so making sure that this one does
        def m.name
          'top level model'
        end

        # Redefining what children are returned for the models rather than fiddling with all of the different kinds of
        # child models that various model classes have
        def m.children
          childless_child_object = generate_model(mixins: [CukeModeler::Named],
                                                  attributes: { name: 'child object 1' })

          child_object_with_children = generate_model(mixins: [CukeModeler::Named, CukeModeler::ModelFactory],
                                                      attributes: { name: 'child object 2' })

          def child_object_with_children.children
            nested_child_object = generate_model(mixins: [CukeModeler::Named],
                                                 attributes: { name: 'grandchild object' })
            [nested_child_object]
          end

          [childless_child_object, child_object_with_children]
        end

        m
      end

      it 'iterates through all of the models in its tree' do
        names = root_model.map(&:name)

        expect(names).to match_array(['top level model', 'child object 1', 'child object 2', 'grandchild object'])
      end

      it 'iterates over the root model first' do
        names = root_model.map(&:name)

        expect(names.first).to eq('top level model')
      end

    end

    context 'without children' do

      let(:root_model) do
        m = clazz.new

        # Not all models have a name, so making sure that this one does
        def m.name
          'top level model'
        end

        # Redefining what children are returned for the model rather than fiddling with all of the different kinds of
        # child models that various model classes have
        def m.children
          []
        end

        m
      end

      it 'iterates through all of the models in its tree' do
        names = root_model.map(&:name)

        expect(names).to match_array(['top level model'])
      end

    end

  end


  it 'can execute code on all models in its model tree' do
    expect(model).to respond_to(:each_model)
  end

  it 'can execute code on all of its descendants' do
    expect(model).to respond_to(:each_descendant)
  end


  context 'without children' do

    let(:parent_model) do
      m = clazz.new

      # Not all models have a name, so making sure that this one does
      def m.name
        'top level model'
      end

      # Redefining what children are returned for the model rather than fiddling with all of the different kinds of
      # child models that various model classes have
      def m.children
        []
      end

      m
    end


    it 'executes the provided code on each descendant of the model' do
      names = []

      parent_model.each_descendant do |descendant_model|
        names << descendant_model.name
      end

      expect(names).to be_empty
    end

    it 'executes the provided code on each model in its tree' do
      names = []

      parent_model.each_model do |model_node|
        names << model_node.name
      end

      expect(names).to match_array(['top level model'])
    end

  end


  context 'with children' do

    let(:parent_model) do
      m = clazz.new

      # Not all models have a name, so making sure that this one does
      def m.name
        'top level model'
      end

      # Redefining what children are returned for the model rather than fiddling with all of the different kinds of
      # child models that various model classes have
      def m.children
        containing_model_stub     = Struct.new(:name, :children)
        non_containing_model_stub = Struct.new(:name)
        nested_child_object       = containing_model_stub.new('grandchild object', [])
        nested_child_object.extend(CukeModeler::Containing)

        non_containing_child_object = non_containing_model_stub.new('child object 1')

        child_object_with_children = containing_model_stub.new('child object 2', [nested_child_object])
        child_object_with_children.extend(CukeModeler::Containing)

        [non_containing_child_object, child_object_with_children]
      end

      m
    end


    it 'executes the provided code on each descendant of the model' do
      names = []

      parent_model.each_descendant do |descendant_model|
        names << descendant_model.name
      end

      expect(names).to match_array(['child object 1', 'child object 2', 'grandchild object'])
    end

    it 'executes the provided code on each model in its tree' do
      names = []

      parent_model.each_model do |model_node|
        names << model_node.name
      end

      expect(names).to match_array(['top level model', 'child object 1', 'child object 2', 'grandchild object'])
    end

  end

end
