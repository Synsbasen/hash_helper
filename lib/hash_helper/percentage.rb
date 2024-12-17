module HashHelper
  module Percentage
    def transform_values_to_percentages(precision: nil)
      total_sum = sum_of_leaves(self)
      return self if total_sum.zero? # If total is zero, return original hash

      calculate_percentages(self, total_sum, precision)
    end

    private

    # Recursively calculate the total sum of all numeric leaf values
    def sum_of_leaves(hash)
      hash.sum do |_k, v|
        v.is_a?(Hash) ? sum_of_leaves(v) : (v.is_a?(Numeric) ? v.to_f : 0.0)
      end.to_f
    end

    # Recursively calculate percentages for each key
    def calculate_percentages(hash, total_sum, precision)
      hash.transform_values do |v|
        if v.is_a?(Hash)
          local_sum = sum_of_leaves(v)
          calculate_percentages(v, local_sum, precision)
        elsif v.is_a?(Numeric)
          percentage = (v.to_f / total_sum * 100)
          precision ? percentage.round(precision) : percentage
        else
          v # Preserve non-numeric and nil values as they are
        end
      end
    end
  end
end
