require "active_support/core_ext/hash/deep_merge"

module HashHelper
  module DeepNormalize
    def deep_normalize(default_value: nil)
      build_default(self, default_value: default_value).deep_merge(self)
    end

    private

    def build_default(obj, default_value: nil)
      return obj.transform_values { default_value } unless obj.values.first.is_a?(Hash)

      # Merge all nested hashes into a single "template"
      merged_template = obj.values.reduce(&:deep_merge)

      # Recursively build the default hash for all keys
      obj.keys.product([build_default(merged_template, default_value: default_value)]).to_h
    end
  end
end
