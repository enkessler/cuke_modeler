require_relative '../../../../../environments/rspec_env'


RSpec.describe 'DocString, Unit', unit_test: true do

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

    it 'contains nothing' do
      expect(doc_string.children).to be_empty
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

      describe 'inspection' do

        it "can inspect a doc string that doesn't have content" do
          doc_string.content = nil
          doc_string_output  = doc_string.inspect

          expect(doc_string_output).to eq('#<CukeModeler::DocString:<object_id> @content: nil>'
                                            .sub('<object_id>', doc_string.object_id.to_s))
        end

        it "can inspect a doc string that has content" do
          doc_string.content = 'foo'
          doc_string_output  = doc_string.inspect

          expect(doc_string_output).to eq('#<CukeModeler::DocString:<object_id> @content: "foo">'
                                            .sub('<object_id>', doc_string.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:doc_string) { clazz.new }


          # The minimal doc string case
          it 'can stringify an empty doc string' do
            doc_string_output = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""', '"""'])
          end

          it 'can stringify a doc string that has only a content type' do
            doc_string.content_type = 'some type'
            doc_string_output       = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['""" some type', '"""'])
          end

          it 'can stringify a doc string that has only content' do
            doc_string.content = 'foo'
            doc_string_output  = doc_string.to_s.split("\n", -1)

            expect(doc_string_output).to eq(['"""', 'foo', '"""'])
          end

        end

      end

    end

  end

end
