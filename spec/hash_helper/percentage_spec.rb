# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/hash/deep_merge"
require_relative "../../lib/hash_helper/percentage"

RSpec.describe "HashHelper::Percentage" do
  describe "#transform_values_to_percentages" do
    it "returns an empty hash when the input hash is empty" do
      hash = {}
      expect(hash.transform_values_to_percentages).to eq({})
    end

    it "calculates percentages for a flat hash" do
      hash = { a: 10, b: 30, c: 60 }
      expected = { a: 10.0, b: 30.0, c: 60.0 }

      expect(hash.transform_values_to_percentages).to eq(expected)
    end

    it "calculates percentages for a nested hash" do
      hash = { a: 10, b: { x: 10, y: 20 } }
      expected = {
        a: 25.0,
        b: {
          x: 33.33,
          y: 66.67
        }
      }

      expect(hash.transform_values_to_percentages(precision: 2)).to eq(expected)
    end

    it "handles deeply nested hashes" do
      hash = { a: 10, b: { x: 10, y: { z: 10, w: 20 } } }
      expected = {
        a: 20.0,
        b: {
          x: 25.0,
          y: {
            z: 33.33,
            w: 66.67
          }
        }
      }

      expect(hash.transform_values_to_percentages(precision: 2)).to eq(expected)
    end

    it "returns raw percentages when precision is 2" do
      hash = { a: 10, b: { x: 10, y: 20 } }
      result = hash.transform_values_to_percentages(precision: 2)

      expect(result[:a]).to eq(25.0)
      expect(result[:b][:x]).to eq(33.33)
      expect(result[:b][:y]).to eq(66.67)
    end

    it "returns raw percentages when precision is not provided" do
      hash = { a: 10, b: { x: 10, y: 20 } }
      result = hash.transform_values_to_percentages

      expect(result[:a]).to eq(25.0)
      expect(result[:b][:x]).to be_within(0.0001).of(33.3333333333)
      expect(result[:b][:y]).to be_within(0.0001).of(66.6666666667)
    end

    it "handles hashes with zero values" do
      hash = { a: 0, b: 0, c: 0 }
      expect(hash.transform_values_to_percentages).to eq({ a: 0.0, b: 0.0, c: 0.0 })
    end

    it "ignores non-numeric values" do
      hash = { a: 10, b: "string", c: { x: 10, y: nil } }
      expected = {
        a: 50.0,
        b: "string",
        c: {
          x: 100.0,
          y: nil
        }
      }

      expect(hash.transform_values_to_percentages(precision: 2)).to eq(expected)
    end
  end
end
