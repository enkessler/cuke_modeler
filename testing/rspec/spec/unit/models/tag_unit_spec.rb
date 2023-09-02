require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Tag, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Tag }
  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has a name' do
      expect(model).to respond_to(:name)
    end

    it 'can change its name' do
      expect(model).to respond_to(:name=)

      model.name = :some_name
      expect(model.name).to eq(:some_name)
      model.name = :some_other_name
      expect(model.name).to eq(:some_other_name)
    end

    it 'contains nothing' do
      expect(model.children).to be_empty
    end

    describe 'abstract instantiation' do

      context 'a new tag object' do

        let(:tag) { clazz.new }


        it 'starts with no name' do
          expect(tag.name).to be_nil
        end

      end

    end

  end


  describe 'tag output' do

    describe 'inspection' do

      it "can inspect a tag that doesn't have a name" do
        model.name   = nil
        model_output = model.inspect

        expect(model_output).to eq('#<CukeModeler::Tag:<object_id> @name: nil>'
                                     .sub('<object_id>', model.object_id.to_s))
      end

      it 'can inspect a tag that has a name' do
        model.name   = 'foo'
        model_output = model.inspect

        expect(model_output).to eq('#<CukeModeler::Tag:<object_id> @name: "foo">'
                                     .sub('<object_id>', model.object_id.to_s))
      end

    end


    describe 'stringification' do

      context 'from abstract instantiation' do

        let(:tag) { clazz.new }


        # The minimal tag case
        it 'can stringify a tag that has only a name' do
          tag.name = '@foo'

          expect(tag.to_s).to eq('@foo')
        end


        describe 'edge cases' do

          # These cases would not produce valid Gherkin and so don't have any useful output
          # but they need to at least not explode

          it 'can stringify an empty tag' do
            expect { tag.to_s }.to_not raise_error
          end

        end

      end

    end

  end

end
