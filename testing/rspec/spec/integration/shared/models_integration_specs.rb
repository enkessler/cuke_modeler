require_relative '../../../../../environments/rspec_env'

shared_examples_for 'a model, integration' do

  # clazz must be defined by the calling file

  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a stringifiable model, integration'

  end

  describe 'unique behavior' do

    it 'inherits from the common model class' do
      expect(model).to be_a(CukeModeler::Model)
    end

  end

end
