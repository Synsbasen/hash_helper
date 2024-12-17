module HashHelper
  module Percentage
    def transform_values_to_percentages(precision: nil)
      total_sum = sum_of_leaves
      return self if total_sum.zero?

      transform_values do |v|
        if v.is_a?(Hash)
          v.transform_values_to_percentages(precision: precision)
        elsif v.is_a?(Numeric)
          percentage = (v.to_f / total_sum * 100)
          precision ? percentage.round(precision) : percentage
        else
          v # Preserve non-numeric and nil values
        end
      end
    end

    def sum_of_leaves
      sum do |_k, v|
        if v.is_a?(Hash)
          v.sum_of_leaves
        elsif v.is_a?(Numeric)
          v.to_f
        else
          0.0
        end
      end.to_f
    end
  end
end
