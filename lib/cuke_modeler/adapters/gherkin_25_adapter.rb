require_relative 'gherkin_20_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 25.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin25Adapter < Gherkin20Adapter; end

  private_constant :Gherkin25Adapter
end
