require_relative 'gherkin_20_adapter'


module CukeModeler

  # @api private
  #
  # An adapter that can convert the output of version 34.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem. Internal helper class.
  class Gherkin34Adapter < Gherkin20Adapter; end

  private_constant :Gherkin34Adapter
end
