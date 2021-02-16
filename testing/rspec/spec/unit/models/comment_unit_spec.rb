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

  end


  describe 'comment output' do

    context 'from abstract instantiation' do

      let(:comment) { clazz.new }


      it 'can output an empty comment' do
        expect { comment.to_s }.to_not raise_error
      end

    end

  end

end
