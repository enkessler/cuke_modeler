module CukeModeler

  # @api private
  #
  # A class providing some basic and common adapter functionality. Internal helper class.
  class GherkinBaseAdapter

    private

    def save_original_data(adapted_ast, raw_ast)
      adapted_ast['cuke_modeler_parsing_data'] = Marshal.load(Marshal.dump(raw_ast))
    end

  end

  private_constant :GherkinBaseAdapter
end
