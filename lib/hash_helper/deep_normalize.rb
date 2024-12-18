require "active_support/core_ext/hash/deep_merge"

module HashHelper
  module DeepNormalize
    # Recursively normalizes the hash by merging it with a default structure.
    #
    # This method creates a nested default structure based on the keys of the hash,
    # assigning each key a specified default value. The resulting structure is then
    # deeply merged with the original hash.
    #
    # @param [Object] default_value The value to assign as the default for all keys
    #   in the normalized structure. Defaults to `nil`.
    # @return [Hash] A new hash that combines the default structure and the original hash.
    #
    # @example Normalize a hash with default values
    #   hash = { a: { x: 1, y: 2 }, b: { z: 3 } }
    #   hash.extend(HashHelper::DeepNormalize)
    #   normalized = hash.deep_normalize(default_value: 0)
    #   # Result: { a: { x: 1, y: 2, z: 0 }, b: { x: 0, y: 0, z: 3 } }
    def deep_normalize(default_value: nil)
      build_default(self, default_value: default_value).deep_merge(self)
    end

    private

    # Builds a default hash structure recursively based on the given hash's keys.
    #
    # This method traverses the nested structure of the hash, constructing a new
    # hash where each key is assigned the specified default value. If the original
    # hash contains nested hashes, the method merges those nested hashes to create
    # a template for the default structure.
    #
    # @param [Hash] obj The hash for which to create a default structure.
    # @param [Object] default_value The value to assign as the default for all keys
    #   in the default structure. Defaults to `nil`.
    # @return [Hash] A new hash with the default structure.
    #
    # @example Build a default structure
    #   hash = { a: { x: 1, y: 2 }, b: { z: 3 } }
    #   build_default(hash, default_value: 0)
    #   # Result: { a: { x: 0, y: 0, z: 0 }, b: { x: 0, y: 0, z: 0 } }
    def build_default(obj, default_value: nil)
      return obj.transform_values { default_value } unless obj.values.first.is_a?(Hash)

      # Merge all nested hashes into a single "template"
      merged_template = obj.values.reduce(&:deep_merge)

      # Recursively build the default hash for all keys
      obj.keys.product([build_default(merged_template, default_value: default_value)]).to_h
    end
  end
end
