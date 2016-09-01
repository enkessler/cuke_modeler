module CukeModeler

  # A mix-in module containing methods used by models that know from which line of
  # source code they originate.

  module Sourceable

    # The line number where the element began in the source code
    attr_accessor :source_line

  end
end
