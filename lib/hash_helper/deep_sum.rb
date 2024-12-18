module HashHelper
  module DeepSum
    # This method calculates the sum of all numeric values in a nested Hash or Array.
    # It recursively traverses the data structure to find and sum up all numbers.
    #
    # @example Example with nested hashes and arrays:
    #   hash = {
    #     a: 1,
    #     b: { c: 2, d: { e: 3, f: 4 } },
    #     g: [5, { h: 6, i: { j: 7 } }]
    #   }
    #   hash.deep_sum # => 28
    def deep_sum
      sum do |_, value|
        case value
        when Hash
          value.deep_sum
        when Array
          value.sum { |v| v.is_a?(Hash) ? v.deep_sum : v.to_f }
        else
          value.to_f
        end
      end
    end
  end
end
