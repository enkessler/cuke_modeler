require_relative 'gherkin_20_adapter'


module CukeModeler

  # @api private
  #
  # An adapter that can convert the output of version 31.x of the *cucumber-gherkin* gem into input that is consumable
  # by this gem. Internal helper class.
  class Gherkin31Adapter < Gherkin20Adapter; end

  private_constant :Gherkin31Adapter
end
