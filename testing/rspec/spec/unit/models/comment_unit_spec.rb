require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Comment, Unit', unit_test: true do

  let(:clazz) { CukeModeler::Comment }
  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a sourced model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has text' do
      expect(model).to respond_to(:text)
    end

    it 'can change its text' do
      expect(model).to respond_to(:text=)

      model.text = :some_text
      expect(model.text).to eq(:some_text)
      model.text = :some_other_text
      expect(model.text).to eq(:some_other_text)
    end

    it 'contains nothing' do
      expect(model.children).to be_empty
    end


    describe 'abstract instantiation' do

      context 'a new comment object' do

        let(:comment) { clazz.new }


        it 'starts with no text' do
          expect(comment.text).to be_nil
        end

      end

    end


    describe 'comment output' do

      describe 'inspection' do

        it 'can inspect a comment that has text' do
          model.text   = 'foo'
          model_output = model.inspect

          expect(model_output).to eq('#<CukeModeler::Comment:<object_id> @text: "foo">'
                                       .sub('<object_id>', model.object_id.to_s))
        end

        it "can inspect a comment that doesn't have text" do
          model.text   = nil
          model_output = model.inspect

          expect(model_output).to eq('#<CukeModeler::Comment:<object_id> @text: nil>'
                                       .sub('<object_id>', model.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:comment) { clazz.new }


          # The maximal comment case
          it 'can stringify a comment that has only text' do
            comment.text = 'foo'

            expect(comment.to_s).to eq('foo')
          end


          describe 'edge cases' do

            # These cases would not produce valid Gherkin and so don't have any useful output
            # but they need to at least not explode

            # The minimal comment case
            it 'can stringify an empty comment' do
              expect { comment.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
