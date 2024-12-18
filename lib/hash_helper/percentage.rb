require 'active_support/core_ext/hash/deep_transform_values'
require_relative "deep_sum"

module HashHelper
  module Percentage
    include HashHelper::DeepSum

    # Transforms all numeric values in the hash into percentages.
    #
    # @param [Boolean] relative If `true`, calculates percentages relative to the current layer.
    #   If `false`, calculates percentages relative to the entire hash. Defaults to `true`.
    # @param [Integer, nil] precision The number of decimal places to round the percentages to. Defaults to no rounding.
    # @return [Hash] A new hash with numeric values transformed into percentages.
    #
    # @example Global percentages (relative: false)
    #   { a: 50, b: { c: 30, d: 20 }, e: 100 }.deep_transform_values_to_percentages
    #   # => { a: 25.0, b: { c: 15.0, d: 10.0 }, e: 50.0 }
    #
    # @example Relative percentages for each layer (relative: true)
    #   { a: 50, b: { c: 30, d: 20 }, e: 100 }.deep_transform_values_to_percentages(relative: true)
    #   # => { a: 50.0, b: { c: 60.0, d: 40.0 }, e: 100.0 }
    def deep_transform_values_to_percentages(relative: true, precision: nil)
      total_sum = deep_sum

      calculate_percentage = lambda do |value|
        return value unless value.is_a?(Numeric)
        return value unless total_sum.positive?

        percentage = (value / total_sum.to_f * 100)
        precision ? percentage.round(precision) : percentage
      end

      unless relative
        return deep_transform_values { |value| calculate_percentage.call(value) }
      end

      transform_values do |value|
        case value
        when Hash
          value.deep_transform_values_to_percentages(relative: relative, precision: precision)
        else
          calculate_percentage.call(value)
        end
      end
    end
  end
end
