require_relative '../../../../../environments/rspec_env'


RSpec.describe 'Model, Unit' do

  let(:clazz) { CukeModeler::Model }
  let(:model) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a model'

  end


  describe 'unique behavior' do

    it 'contains nothing' do
      expect(model.children).to be_empty
    end


    describe 'model output' do

      describe 'inspection' do

        it "can inspect a model" do
          model_output = model.inspect

          expect(model_output).to eq('#<CukeModeler::Model:<object_id>>'
                                       .sub('<object_id>', model.object_id.to_s))
        end

      end


      describe 'stringification' do

        context 'from abstract instantiation' do

          let(:model) { clazz.new }


          describe 'edge cases' do

            # The base model class isn't meant to be used directly, so any stringified output
            # is inherently unspecified and just needs to not explode

            it 'can stringify an empty model' do
              expect { model.to_s }.to_not raise_error
            end

          end

        end

      end

    end

  end

end
