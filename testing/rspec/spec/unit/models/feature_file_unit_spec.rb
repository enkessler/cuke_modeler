require_relative '../../../../../environments/rspec_env'


RSpec.describe 'FeatureFile, Unit', unit_test: true do

  let(:clazz) { CukeModeler::FeatureFile }
  let(:feature_file) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'
    it_should_behave_like 'a parsed model'

  end


  describe 'unique behavior' do

    it 'has a path' do
      expect(feature_file).to respond_to(:path)
    end

    it 'can change its path' do
      expect(feature_file).to respond_to(:path=)

      feature_file.path = :some_path
      expect(feature_file.path).to eq(:some_path)
      feature_file.path = :some_other_path
      expect(feature_file.path).to eq(:some_other_path)
    end

    it 'has a feature' do
      expect(feature_file).to respond_to(:feature)
    end

    it 'can change its feature' do
      expect(feature_file).to respond_to(:feature=)

      feature_file.feature = :some_features
      expect(feature_file.feature).to eq(:some_features)
      feature_file.feature = :some_other_features
      expect(feature_file.feature).to eq(:some_other_features)
    end

    it 'has comments' do
      expect(feature_file).to respond_to(:comments)
    end

    it 'can change its comments' do
      expect(feature_file).to respond_to(:comments=)

      feature_file.comments = :some_comments
      expect(feature_file.comments).to eq(:some_comments)
      feature_file.comments = :some_other_comments
      expect(feature_file.comments).to eq(:some_other_comments)
    end

    it 'knows the name of the file that it is modeling' do
      expect(feature_file).to respond_to(:name)
    end

    it 'derives its file name from its path' do
      feature_file.path = 'path/to/foo'

      expect(feature_file.name).to eq('foo')
    end


    describe 'abstract instantiation' do

      context 'a new feature file object' do

        let(:feature_file) { clazz.new }


        it 'starts with no path' do
          expect(feature_file.path).to be_nil
        end

        it 'starts with no name' do
          expect(feature_file.name).to be_nil
        end

        it 'starts with no feature' do
          expect(feature_file.feature).to be_nil
        end

        it 'starts with no comments' do
          expect(feature_file.comments).to eq([])
        end

      end

    end

    it 'contains a feature' do
      feature = :a_feature
      everything = [feature]

      feature_file.feature = feature

      expect(feature_file.children).to match_array(everything)
    end


    describe 'feature file output' do

      describe 'inspection' do

        it 'can inspect a feature file that has a path' do
          feature_file.path   = 'foo'
          feature_file_output = feature_file.inspect

          expect(feature_file_output).to eq('#<CukeModeler::FeatureFile:<object_id> @path: "foo">'
                                              .sub('<object_id>', feature_file.object_id.to_s))
        end

        it "can inspect a feature file that doesn't have a path" do
          feature_file.path   = nil
          feature_file_output = feature_file.inspect

          expect(feature_file_output).to eq('#<CukeModeler::FeatureFile:<object_id> @path: nil>'
                                              .sub('<object_id>', feature_file.object_id.to_s))
        end

      end

      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:feature_file) { clazz.new }


          # The maximal feature file case
          it 'can stringify a feature file that has only a path' do
            feature_file.path = 'foo'

            expect(feature_file.to_s).to eq('foo')
          end


          describe 'edge cases' do

            # These cases would not produce valid file paths and so don't have any useful output
            # but they need to at least not explode

            # The minimal feature file case
            it 'can stringify an empty feature_file' do
              expect { feature_file.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
