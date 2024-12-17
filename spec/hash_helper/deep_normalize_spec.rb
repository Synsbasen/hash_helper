# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/hash_helper/deep_normalize"

RSpec.describe "HashHelper::DeepNormalize" do
  describe "#deep_normalize" do
    it "fills missing leaf values with the default value" do
      hash = { a: { x: 1 }, b: { x: 2, y: 3 }, c: { z: 4 } }
      normalized_hash = hash.deep_normalize(default_value: 0)

      expected_result = {
        a: { x: 1, y: 0, z: 0 },
        b: { x: 2, y: 3, z: 0 },
        c: { x: 0, y: 0, z: 4 }
      }

      expect(normalized_hash).to eq(expected_result)
    end

    it "handles empty hashes gracefully" do
      hash = {}
      normalized_hash = hash.deep_normalize(default_value: 0)

      expect(normalized_hash).to eq({})
    end
  end
end
