require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Step, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Step }
  let(:step) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a keyworded model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has text' do
      expect(step).to respond_to(:text)
    end

    it 'can change its text' do
      expect(step).to respond_to(:text=)

      step.text = :some_text
      expect(step.text).to eq(:some_text)
      step.text = :some_other_text
      expect(step.text).to eq(:some_other_text)
    end

    it 'has a block' do
      expect(step).to respond_to(:block)
    end

    it 'can change its block' do
      expect(step).to respond_to(:block=)

      step.block = :some_block
      expect(step.block).to eq(:some_block)
      step.block = :some_other_block
      expect(step.block).to eq(:some_other_block)
    end


    describe 'abstract instantiation' do

      context 'a new step object' do

        let(:step) { clazz.new }


        it 'starts with no text' do
          expect(step.text).to be_nil
        end

        it 'starts with no block' do
          expect(step.block).to be_nil
        end

      end

    end

    it 'contains some kind of block' do
      block = :block
      everything = [block]

      step.block = block

      expect(step.children).to match_array(everything)
    end


    describe 'step output' do

      describe 'inspection' do

        it 'can inspect a step that has text' do
          step.text   = 'foo'
          step_output = step.inspect

          expect(step_output).to eq('#<CukeModeler::Step:<object_id> @text: "foo">'
                                      .sub('<object_id>', step.object_id.to_s))
        end

        it "can inspect a step that doesn't have text" do
          step.text   = nil
          step_output = step.inspect

          expect(step_output).to eq('#<CukeModeler::Step:<object_id> @text: nil>'
                                      .sub('<object_id>', step.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:step) { clazz.new }


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            it 'can stringify an empty step' do
              expect { step.to_s }.to_not raise_error
            end

            it 'can stringify a step that has only a keyword' do
              step.keyword = 'foo'

              expect { step.to_s }.to_not raise_error
            end

            it 'can stringify a step that has only text' do
              step.text = 'step text'

              expect { step.to_s }.to_not raise_error
            end

          end

        end

      end

    end

    it 'can gracefully be compared to other types of objects' do
      # Some common types of object
      [1, 'foo', :bar, [], {}, nil].each do |thing|
        expect { step == thing }.to_not raise_error
        expect(step == thing).to be false
      end
    end

  end

end
