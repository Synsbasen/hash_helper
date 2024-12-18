module HashHelper
  module DeepInvert
    # Deeply inverts a hash, creating a new structure where the values in the original
    # hash are moved outward, and the keys are reversed in the nesting.
    #
    # @return [Hash] A new hash with the keys and values deeply inverted.
    #
    # @example Deeply invert a nested hash
    #   hash = { a: { b: { c: 1 } }, d: { e: 2 } }
    #   hash.extend(HashHelper::DeepInvert)
    #   inverted = hash.deep_invert
    #   # Result: { c: { b: { a: 1 } }, e: { d: 2 } }
    def deep_invert
      each_with_object({}) do |(outer_key, outer_value), result|
        traverse_and_invert(outer_value, [outer_key], result)
      end
    end

    private

    # Recursively traverses and inverts a nested hash, tracking the full key path.
    #
    # This method traverses through the current hash and builds an inverted structure
    # in the result hash. It uses the key path to reverse the nesting and assign values.
    #
    # @param [Hash] current_hash The hash being traversed.
    # @param [Array] path The path of keys leading to the current value.
    # @param [Hash] result The hash being built with the inverted structure.    def traverse_and_invert(current_hash, path, result)
    def traverse_and_invert(current_hash, path, result)
      current_hash.each do |key, value|
        if value.is_a?(Hash)
          traverse_and_invert(value, path + [key], result)
        else
          insert_inverted_path(result, path + [key], value)
        end
      end
    end

    # Inserts a value into the inverted structure at the specified key path.
    #
    # This method traverses the `result` hash using the reversed key path,
    # creating nested structures as necessary, and assigns the value to the outermost key.
    #
    # @param [Hash] result The hash where the inverted structure is being built.
    # @param [Array] keys The reversed key path to the value.
    # @param [Object] value The value to assign at the end of the key path.
    def insert_inverted_path(result, keys, value)
      current = result

      # Last key (leaf) holds the outer key and value
      keys[1..-1].reverse.each do |key|
        current[key] ||= {}
        current = current[key]
      end

      current[keys.first] = value
    end
  end
end
