module HashHelper
  module Percentage
    def transform_values_to_percentages(precision: nil)
      total_sum = deep_sum
      return self if total_sum.zero?

      transform_values do |value|
        case value
        when Hash
          value.transform_values_to_percentages(precision: precision)
        when Numeric
          percentage = (value / deep_sum * 100)
          precision ? percentage.round(precision) : percentage
        else
          value
        end
      end
    end
  end
end
