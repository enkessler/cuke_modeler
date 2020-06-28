require "#{File.dirname(__FILE__)}/../spec_helper"


describe 'Parsing, Integration' do

  let(:nodule) { CukeModeler::Parsing }


  describe 'unique behavior' do

    it 'will complain if using an unknown version of `gherkin`' do
      original_version = Gem.loaded_specs['cucumber-gherkin'].version
      unknown_version  = Gem::Version.new('0.0.0')

      begin
        Gem.loaded_specs['cucumber-gherkin'].instance_variable_set(:@version, unknown_version)

        expect { load "#{File.dirname(__FILE__)}/../../../../lib/cuke_modeler/parsing.rb" }.to raise_error("Unknown Gherkin version: '0.0.0'")
      ensure
        Gem.loaded_specs['cucumber-gherkin'].instance_variable_set(:@version, original_version)
      end
    end

    it 'loads the correct dialects based on the version of Gherkin used' do
      expect(nodule.dialects).to equal(Gherkin::DIALECTS)
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
      expect { nodule.parse_text("#{FEATURE_KEYWORD}:") }.to_not raise_error
    end

    it 'includes the type of object provided when raising an non-string exception' do
      expect { nodule.parse_text(:not_a_string) }.to raise_error(ArgumentError, /Symbol/)
    end

    it 'returns an AST rooted at the feature file level' do
      result = nodule.parse_text("#{FEATURE_KEYWORD}:")
      expect(result).to be_a(Hash)
      expect(result.keys).to include('feature')
    end

    it 'raises an error if an error is encountered while parsing text' do
      expect { nodule.parse_text('bad file') }.to raise_error(ArgumentError, /Error encountered while parsing '.*'/)
    end

    it 'includes the file parsed in the error that it raises' do
      expect { nodule.parse_text('bad file', 'file foo.txt') }.to raise_error(/'file foo\.txt'/)
    end

    it 'has a default file name used while parsing if one is not provided' do
      expect { nodule.parse_text('bad file') }.to raise_error(ArgumentError, /'cuke_modeler_fake_file\.feature'/)
    end

    it 'includes the underlying error message in the error that it raises' do
      begin
        $old_method = CukeModeler::Parsing.method(:parsing_method)

        # Custom error type in order to ensure that we are throwing the correct thing
        module CukeModeler
          class TestError < StandardError
          end
        end

        # Monkey patch the parsing method to throw the error that we need for testing
        module CukeModeler
          module Parsing
            class << self
              def parsing_method(*args)
                raise(CukeModeler::TestError, 'something went wrong')
              end
            end
          end
        end


        expect { nodule.parse_text('bad file') }.to raise_error(/CukeModeler::TestError.*something went wrong/)
      ensure
        # Making sure that our changes don't escape a test and ruin the rest of the suite
        module CukeModeler
          module Parsing
            class << self
              define_method(:parsing_method, $old_method)
            end
          end
        end
      end

    end

    describe 'parsing invalid Gherkin' do

      it 'correctly bubbles up parsing errors' do
        expect { nodule.parse_text('bad file') }.to raise_error(/RuntimeError.*#EOF/)
      end

    end

    describe 'text encoding' do
      let(:text) { 'Feature:'.encode('ASCII') }

      it 'encodes text as UTF-8 before parsing' do
        begin
          $old_method = CukeModeler::Parsing.method(:parsing_method)

          # Monkey patch the parsing method in order to capture the information that we need for testing
          module CukeModeler
            module Parsing
              class << self
                def parsing_method(source_text, *args)
                  $source_text_received = source_text

                  # Short circuit the rest of the parsing process
                  fail
                end
              end
            end
          end

          begin
            nodule.parse_text(text)
          rescue
            expect($source_text_received.encoding.to_s).to eq('UTF-8')
          end
        ensure
          # Making sure that our changes don't escape a test and ruin the rest of the suite
          module CukeModeler
            module Parsing
              class << self
                define_method(:parsing_method, $old_method)
              end
            end
          end
        end

      end

    end

  end

end
