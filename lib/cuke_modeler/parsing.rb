require 'stringio'
require 'gherkin/formatter/json_formatter'
require 'gherkin'
require 'json'
require 'multi_json'

module CukeModeler

  # A module providing source text parsing functionality.

  module Parsing

    class << self

      # Parses the Cucumber feature given in *source_text* and returns an array
      # containing the hash representation of its logical structure.
      def parse_text(source_text)
        raise(ArgumentError, "Cannot parse #{source_text.class} objects. Strings only.") unless source_text.is_a?(String)

        io = StringIO.new
        formatter = Gherkin::Formatter::JSONFormatter.new(io)
        parser = Gherkin::Parser::Parser.new(formatter)
        parser.parse(source_text, 'fake_file.txt', 0)
        formatter.done

        MultiJson.load(io.string)
      end

    end

  end
end
