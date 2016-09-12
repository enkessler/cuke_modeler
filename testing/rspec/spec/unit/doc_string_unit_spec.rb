require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'DocString, Unit', :unit_test => true do

  let(:clazz) { CukeModeler::DocString }
  let(:doc_string) { clazz.new }

  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a parsed model'
    it_should_behave_like 'a sourced model'

  end


  describe 'unique behavior' do

    it 'has a content type' do
      expect(doc_string).to respond_to(:content_type)
    end

    it 'can change its content type' do
      expect(doc_string).to respond_to(:content_type=)

      doc_string.content_type = :some_content_type
      expect(doc_string.content_type).to eq(:some_content_type)
      doc_string.content_type = :some_other_content_type
      expect(doc_string.content_type).to eq(:some_other_content_type)
    end

    it 'has content' do
      expect(doc_string).to respond_to(:content)
    end

    it 'can change its content' do
      expect(doc_string).to respond_to(:content=)

      doc_string.content = :some_content
      expect(doc_string.content).to eq(:some_content)
      doc_string.content = :some_other_content
      expect(doc_string.content).to eq(:some_other_content)
    end


    describe 'abstract instantiation' do

      context 'a new doc string object' do

        let(:doc_string) { clazz.new }


        it 'starts with no content type' do
          expect(doc_string.content_type).to be_nil
        end

        it 'starts with no content' do
          expect(doc_string.content).to be_nil
        end

      end

    end


    describe 'doc string output' do

      it 'is a String' do
        expect(doc_string.to_s).to be_a(String)
      end


      context 'from abstract instantiation' do

        context 'a new doc string object' do

          let(:doc_string) { clazz.new }


          it 'can output an empty doc string' do
            expect { doc_string.to_s }.to_not raise_error
          end

          it 'can output a doc string that has only a content type' do
            doc_string.content_type = 'some type'

            expect { doc_string.to_s }.to_not raise_error
          end

          it 'can output a doc string that has only content' do
            doc_string.content = 'foo'

            expect { doc_string.to_s }.to_not raise_error
          end

        end

      end

    end

  end

end
