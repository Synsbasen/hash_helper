module HashHelper
  module Percentage
    def transform_values_to_percentages(precision: nil)
      total_sum = deep_sum
      return self if total_sum.zero?

      transform_values do |v|
        if v.is_a?(Hash)
          v.transform_values_to_percentages(precision: precision)
        elsif v.is_a?(Numeric)
          percentage = (v.to_f / deep_sum * 100)
          precision ? percentage.round(precision) : percentage
        else
          v
        end
      end
    end
  end
end
