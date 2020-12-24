require 'digest/md5'

module CukeModeler

  # NOT A PART OF THE PUBLIC API
  # A mix-in module containing methods used by models that represent an element that has a name.

  module Fingerprint

    # NOTE: create a fingerprint for the given model using Digest::MD5
    def fingerprint
      # NOTE: yield the result value of the block as the argument to .hexdigest
      if block_given?
        value = yield self

        # NOTE: The block returned nil, nothing to digest here
        return nil unless value.present?

        return Digest::MD5.hexdigest(value)
      end

      # NOTE: no block given, .hexdigest the to_s of the model
      return Digest::MD5.hexdigest(to_s)
    end

  end

end
