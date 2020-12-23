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

        # NOTE: The block returned nil, nothing to hexdigest here
        return nil unless value.present?

        return Digest::MD5.hexdigest(value)
      end

      # NOTE: no block given, .hexdigest the to_s of the model
      return Digest::MD5.hexdigest(to_s)
    end

    # NOTE: create a fingerprint for the given model's children using Digest::MD5
    def fingerprint_children(depth = 0)
      if children.empty?
        fail 'dont invoke fingerprint_children on a model without children' if depth == 0

        return fingerprint { |m| yield m } if block_given?
        return fingerprint
      end

      # NOTE: aggregate the fingerprints of all it's children
      fingerprints = children.map do |child|
        if block_given?
          child.fingerprint_children(depth+1) { |c| yield c }
        else
          child.fingerprint_children(depth+1)
        end
      end.compact

      # NOTE: create a .hexdigest of the combined fingerprint of all children
      Digest::MD5.hexdigest(fingerprints.join)
    end
  end
end
