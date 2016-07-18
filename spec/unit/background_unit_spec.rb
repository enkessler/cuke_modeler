require 'spec_helper'


describe 'Background, Unit' do

  let(:clazz) { CukeModeler::Background }
  let(:background) { clazz.new }


  describe 'common behavior' do

    it_should_behave_like 'a modeled element'
    it_should_behave_like 'a named element'
    it_should_behave_like 'a described element'
    it_should_behave_like 'a stepped element'
    it_should_behave_like 'a sourced element'
    it_should_behave_like 'a parsed element'

  end


  describe 'unique behavior' do

    it 'can be instantiated with the minimum viable Gherkin' do
      source = 'Background:'

      expect { clazz.new(source) }.to_not raise_error
    end

    it 'provides a descriptive filename when being parsed from stand alone text' do
      source = "bad background text \n Background:\n And a step\n @foo "

      expect { clazz.new(source) }.to raise_error(/'cuke_modeler_stand_alone_background\.feature'/)
    end

    it 'trims whitespace from its source description' do
      source = ['Background:',
                '  ',
                '        description line 1',
                '',
                '   description line 2',
                '     description line 3               ',
                '',
                '',
                '',
                '  * a step']
      source = source.join("\n")

      background = clazz.new(source)
      description = background.description.split("\n")

      expect(description).to eq(['     description line 1',
                                 '',
                                 'description line 2',
                                 '  description line 3'])
    end

    it 'contains steps' do
      steps = [:step_1, :step_2]
      everything = steps

      background.steps = steps

      expect(background.children).to match_array(everything)
    end


    describe 'model population' do

      context 'from source text' do

        context 'a filled background' do

          let(:source_text) { "Background: Background name

                               Background description.

                             Some more.
                                 Even more." }
          let(:background) { clazz.new(source_text) }


          it "models the background's name" do
            expect(background.name).to eq('Background name')
          end

          it "models the background's description" do
            description = background.description.split("\n")

            expect(description).to eq(['  Background description.',
                                       '',
                                       'Some more.',
                                       '    Even more.'])
          end

        end

        context 'an empty background' do

          let(:source_text) { 'Background:' }
          let(:background) { clazz.new(source_text) }

          it "models the background's name" do
            expect(background.name).to eq('')
          end

          it "models the background's description" do
            expect(background.description).to eq('')
          end

        end

      end

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

      it 'is a String' do
        expect(background.to_s).to be_a(String)
      end


      context 'from source text' do

        it 'can output an empty background' do
          source = ['Background:']
          source = source.join("\n")
          background = clazz.new(source)

          background_output = background.to_s.split("\n")

          expect(background_output).to eq(['Background:'])
        end

        it 'can output a background that has a name' do
          source = ['Background: test background']
          source = source.join("\n")
          background = clazz.new(source)

          background_output = background.to_s.split("\n")

          expect(background_output).to eq(['Background: test background'])
        end

        it 'can output a background that has a description' do
          source = ['Background:',
                    'Some description.',
                    'Some more description.']
          source = source.join("\n")
          background = clazz.new(source)

          background_output = background.to_s.split("\n")

          expect(background_output).to eq(['Background:',
                                           '',
                                           'Some description.',
                                           'Some more description.'])
        end

      end


      context 'from abstract instantiation' do

        let(:background) { clazz.new }


        it 'can output an empty background' do
          expect { background.to_s }.to_not raise_error
        end

        it 'can output a background that has only a name' do
          background.name = 'a name'

          expect { background.to_s }.to_not raise_error
        end

        it 'can output a background that has only a description' do
          background.description = 'a description'

          expect { background.to_s }.to_not raise_error
        end

      end

    end

  end

end
