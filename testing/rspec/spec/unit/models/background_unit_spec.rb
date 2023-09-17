require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Background, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Background }
  let(:background) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a named model'
    it_should_behave_like 'a described model'
    it_should_behave_like 'a stepped model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'contains steps' do
      steps = [:step_1, :step_2]
      everything = steps

      background.steps = steps

      expect(background.children).to match_array(everything)
    end


    describe 'comparison' do

      it 'can gracefully be compared to other types of objects' do
        # Some common types of object
        [1, 'foo', :bar, [], {}].each do |thing|
          expect { background == thing }.to_not raise_error
          expect(background == thing).to be false
        end
      end

    end


    describe 'background output' do

      describe 'inspection' do

        it "can inspect a background that doesn't have a name" do
          background.name   = nil
          background_output = background.inspect

          expect(background_output).to eq('#<CukeModeler::Background:<object_id> @name: nil>'
                                            .sub('<object_id>', background.object_id.to_s))
        end

        it 'can inspect a background that has a name' do
          background.name   = 'a name'
          background_output = background.inspect

          expect(background_output).to eq('#<CukeModeler::Background:<object_id> @name: "a name">'
                                            .sub('<object_id>', background.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:background) { clazz.new }


          it 'can stringify a background that has only a keyword' do
            background.keyword = 'foo'

            expect(background.to_s).to eq('foo:')
          end


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            # The minimal background case
            it 'can stringify an empty background' do
              expect { background.to_s }.to_not raise_error
            end

            it 'can stringify a background that has only a name' do
              background.name = 'a name'

              expect { background.to_s }.to_not raise_error
            end

            it 'can stringify a background that has only a description' do
              background.description = 'a description'

              expect { background.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
