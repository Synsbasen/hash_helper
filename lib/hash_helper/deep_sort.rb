module HashHelper
  module DeepSort
    # Recursively sorts the hash by keys in lexicographic order.
    #
    # @return [Hash] A new hash with keys sorted lexicographically.
    #
    # @example Sort a flat hash
    #   { "b" => 1, "a" => 2, "c" => 3 }.deep_sort
    #   # => { "a" => 2, "b" => 1, "c" => 3 }
    #
    # @example Sort a nested hash
    #   { "b" => { "d" => 2, "c" => 1 }, "a" => { "e" => 3, "f" => 4 } }.deep_sort
    #   # => { "a" => { "e" => 3, "f" => 4 }, "b" => { "c" => 1, "d" => 2 } }
    def deep_sort
      deep_sort_by { |key, _value| key }
    end
    
    # Recursively sorts the hash by a custom block.
    #
    # @yieldparam [String, Symbol] key The current key being evaluated for sorting.
    # @yieldparam [Object] value The current value associated with the key.
    # @return [Hash] A new hash with keys sorted based on the provided block.
    #
    # @example Sort by key length
    #   { "apple" => 1, "pear" => 2 }.deep_sort_by { |key, _value| key.length }
    #   # => { "pear" => 2, "apple" => 1 }
    #
    # @example Sort by value
    #   { "a" => 3, "b" => 1 }.deep_sort_by { |_key, value| value }
    #   # => { "b" => 1, "a" => 3 }
    #
    # @example Place 'null' at the end
    #   { "b" => 1, "a" => 2, "null" => 3 }.deep_sort_by { |key, _value| key == "null" ? 1 : 0 }
    #   # => { "a" => 2, "b" => 1, "null" => 3 }
    def deep_sort_by(&block)
      sorted_pairs = sort_by do |key, value|
        block.call(key, value.is_a?(Hash) ? nil : value)
      end
  
      sorted_pairs.each_with_object({}) do |(key, value), result|
        result[key] = value.is_a?(Hash) ? value.deep_sort_by(&block) : value
      end
    end
  end
end
