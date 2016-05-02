require 'spec_helper'

SimpleCov.command_name('Parsing') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Parsing, Unit' do

  let(:nodule) { CukeModeler::Parsing }


  describe 'unique behavior' do

    it 'can parse text' do
      nodule.should respond_to(:parse_text)
    end

    it 'can only parse strings' do
      expect { nodule.parse_text(5) }.to raise_error(ArgumentError)
      expect { nodule.parse_text('Feature:') }.to_not raise_error
    end

    it 'returns an Array' do
      result = nodule.parse_text('Feature:')
      result.is_a?(Array).should be_true
    end

    it 'takes the text that is to be parsed and an optional file name' do
      expect(nodule.method(:parse_text).arity).to eq(-2)
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
