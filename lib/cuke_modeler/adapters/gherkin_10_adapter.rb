require_relative 'gherkin_9_adapter'


module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # An adapter that can convert the output of version 10.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem.

  class Gherkin10Adapter < Gherkin9Adapter; end

  private_constant :Gherkin10Adapter
end
