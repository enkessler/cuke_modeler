require_relative 'gherkin_9_adapter'


module CukeModeler

  # @api private
  #
  # An adapter that can convert the output of version 16.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem. Internal helper class.
  class Gherkin16Adapter < Gherkin9Adapter; end

  private_constant :Gherkin16Adapter
end
