require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Outline, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Outline }
  let(:outline) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a stepped model'
    it_should_behave_like 'a tagged model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has examples' do
      expect(outline).to respond_to(:examples)
    end

    it 'can change its examples' do
      expect(outline).to respond_to(:examples=)

      outline.examples = :some_examples
      expect(outline.examples).to eq(:some_examples)
      outline.examples = :some_other_examples
      expect(outline.examples).to eq(:some_other_examples)
    end


    describe 'abstract instantiation' do

      context 'a new outline object' do

        let(:outline) { clazz.new }


        it 'starts with no examples' do
          expect(outline.examples).to eq([])
        end

      end

    end

    it 'contains steps, examples, and tags' do
      tags = [:tag_1, :tagt_2]
      steps = [:step_1, :step_2, :step_3]
      examples = [:example_1, :example_2, :example_3]
      everything = steps + examples + tags

      outline.steps = steps
      outline.examples = examples
      outline.tags = tags

      expect(outline.children).to match_array(everything)
    end


    describe 'comparison' do

      it 'can gracefully be compared to other types of objects' do
        # Some common types of object
        [1, 'foo', :bar, [], {}].each do |thing|
          expect { outline == thing }.to_not raise_error
          expect(outline == thing).to be false
        end
      end

    end


    describe 'outline output' do

      describe 'inspection' do

        it "can inspect an outline that doesn't have a name" do
          outline.name   = nil
          outline_output = outline.inspect

          expect(outline_output).to eq('#<CukeModeler::Outline:<object_id> @name: nil>'
                                         .sub('<object_id>', outline.object_id.to_s))
        end

        it 'can inspect an outline that has a name' do
          outline.name   = 'a name'
          outline_output = outline.inspect

          expect(outline_output).to eq('#<CukeModeler::Outline:<object_id> @name: "a name">'
                                         .sub('<object_id>', outline.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:outline) { clazz.new }


          # The minimal outline case
          it 'can stringify an outline that has only a keyword' do
            outline.keyword = 'foo'

            expect(outline.to_s).to eq('foo:')
          end


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            it 'can stringify an empty outline' do
              expect { outline.to_s }.to_not raise_error
            end

            it 'can stringify an outline that has only a name' do
              outline.name = 'a name'

              expect { outline.to_s }.to_not raise_error
            end

            it 'can stringify an outline that has only a description' do
              outline.description = 'a description'

              expect { outline.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
