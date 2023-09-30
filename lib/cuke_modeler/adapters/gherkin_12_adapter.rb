require_relative 'gherkin_9_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 12.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin12Adapter < Gherkin9Adapter; end

  private_constant :Gherkin12Adapter
end
