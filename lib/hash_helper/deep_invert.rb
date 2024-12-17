module HashHelper
  module DeepInvert
    def deep_invert
      result = {}

      each do |outer_key, outer_value|
        traverse_and_invert(outer_value, [outer_key], result)
      end

      result
    end

    private

    # Traverse and invert while tracking full key path
    def traverse_and_invert(current_hash, path, result)
      current_hash.each do |key, value|
        if value.is_a?(Hash)
          traverse_and_invert(value, path + [key], result)
        else
          insert_inverted_path(result, path + [key], value)
        end
      end
    end

    # Build nested structure for the result hash
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
