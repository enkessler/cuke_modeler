require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Parsing, Integration' do

  let(:nodule) { CukeModeler::Parsing }


  describe 'unique behavior' do

    it 'loads the correct dialects based on the version of Gherkin used', :gherkin3 => true, :gherkin4 => true do
      expect(nodule.dialects).to equal(Gherkin::DIALECTS)
    end

    it 'loads the correct dialects based on the version of Gherkin used', :gherkin2 => true do
      expect(nodule.dialects).to equal(Gherkin::I18n::LANGUAGES)
    end

    it 'can parse text that uses a non-default dialect' do
      source_text = "# language: en-au
                     Pretty much:

                       First off:
                         Y'know foo

                       Awww, look mate:
                         It's just unbelievable that zip
                         But at the end of the day I reckon bar

                       Reckon it's like:
                         Yeah nah zen
                         Too right baz
                         You'll wanna:
                           | param |
                           | value |"

      expect { nodule.parse_text(source_text) }.to_not raise_error
    end

    it 'raises and error if given something to parse besides a string' do
      expect { nodule.parse_text(5) }.to raise_error(ArgumentError, /Text to parse must be a String but got/)
      expect { nodule.parse_text("#{@feature_keyword}:") }.to_not raise_error
    end

    it 'includes the type of object provided when raising an non-string exception' do
      expect { nodule.parse_text(5) }.to raise_error(ArgumentError, /Fixnum/)
    end

    # todo - Stop doing this. Just return a feature file rooted AST.
    it 'returns an Array' do
      result = nodule.parse_text("#{@feature_keyword}:")
      expect(result).to be_a(Array)
    end

    it 'raises and error if an error is encountered while parsing text' do
      expect { nodule.parse_text('bad file') }.to raise_error(ArgumentError, /Error encountered while parsing '.*'/)
    end

    it 'includes the file parsed in the error that it raises' do
      expect { nodule.parse_text('bad file', 'file foo.txt') }.to raise_error(/'file foo\.txt'/)
    end

    it 'includes the underlying error message in the error that it raises' do
      begin
        # Custom error type in order to ensure that we are throwing the correct thing
        module CukeModeler
          class TestError < StandardError
          end
        end

        # Monkey patch Gherkin to throw the error that we need for testing
        if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
          old_method = Gherkin::Parser.instance_method(:parse)

          module Gherkin
            class Parser
              def parse(*args)
                raise(CukeModeler::TestError, 'something went wrong')
              end
            end
          end
        else
          old_method = Gherkin::Parser::Parser.instance_method(:parse)

          module Gherkin
            module Parser
              class Parser
                def parse(*args)
                  raise(CukeModeler::TestError, 'something went wrong')
                end
              end
            end
          end
        end

        expect { nodule.parse_text('bad file') }.to raise_error(/CukeModeler::TestError.*something went wrong/)
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        if Gem.loaded_specs['gherkin'].version.version[/^3|4/]
          Gherkin::Parser.send(:define_method, :parse, old_method)
        else
          Gherkin::Parser::Parser.send(:define_method, :parse, old_method)
        end
      end

    end

    it 'has a default file name if one is not provided' do
      expect { nodule.parse_text('bad file') }.to raise_error(ArgumentError, /'cuke_modeler_fake_file\.feature'/)
    end

  end

end
