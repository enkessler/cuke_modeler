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

      context 'from abstract instantiation' do

        let(:feature_file) { clazz.new }


        it 'can output an empty feature file' do
          expect { feature_file.to_s }.to_not raise_error
        end

      end

    end

  end

end
