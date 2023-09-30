require_relative 'gherkin_20_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 27.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin27Adapter < Gherkin20Adapter; end

  private_constant :Gherkin27Adapter
end
