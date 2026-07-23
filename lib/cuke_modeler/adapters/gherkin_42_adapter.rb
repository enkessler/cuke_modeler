require_relative 'gherkin_20_adapter'


module CukeModeler

  # @api private
  #
  # An adapter that can convert the output of version 42.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem. Internal helper class.
  class Gherkin42Adapter < Gherkin20Adapter; end

  private_constant :Gherkin42Adapter
end
