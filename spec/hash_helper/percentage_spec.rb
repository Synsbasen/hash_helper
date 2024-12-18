# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/hash/deep_merge"
require_relative "../../lib/hash_helper/percentage"

RSpec.describe "HashHelper::Percentage" do
  describe "#deep_transform_values_to_percentages with relative: false" do
    context "when calculating global percentages" do
      it "calculates percentages for a flat hash" do
        hash = { a: 50, b: 50, c: 100 }
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({ a: 25.0, b: 25.0, c: 50.0 })
      end

      it "calculates percentages for a nested hash relative to the global total sum" do
        hash = { a: 50, b: { c: 30, d: 20 }, e: 100 }
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({
          a: 25.0,
          b: { c: 15.0, d: 10.0 },
          e: 50.0
        })
      end

      it "handles a hash with mixed types and calculates percentages only for numeric values" do
        hash = { a: 50, b: "string", c: { x: 10, y: nil, z: 40 } }
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({
          a: 50.0,
          b: "string",
          c: { x: 10.0, y: nil, z: 40.0 }
        })
      end

      it "handles a hash with zero total sum" do
        hash = { a: 0, b: { c: 0, d: 0 } }
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({ a: 0, b: { c: 0, d: 0 } })
      end
    end

    context "when precision is specified" do
      it "rounds percentages to the specified number of decimal places" do
        hash = { a: 33.333, b: 66.667 }
        result = hash.deep_transform_values_to_percentages(relative: false, precision: 1)
        expect(result).to eq({ a: 33.3, b: 66.7 })
      end

      it "handles nested hashes with precision" do
        hash = { a: 50, b: { c: 30, d: 20 }, e: 100 }
        result = hash.deep_transform_values_to_percentages(relative: false, precision: 2)
        expect(result).to eq({
          a: 25.0,
          b: { c: 15.0, d: 10.0 },
          e: 50.0
        })
      end
    end

    context "edge cases" do
      it "returns an empty hash when the input is empty" do
        hash = {}
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({})
      end

      it "preserves non-numeric and nil values" do
        hash = { a: 50, b: nil, c: "non-numeric", d: { e: 50, f: nil } }
        result = hash.deep_transform_values_to_percentages(relative: false)
        expect(result).to eq({
          a: 50.0,
          b: nil,
          c: "non-numeric",
          d: { e: 50.0, f: nil }
        })
      end
    end
  end

  describe "#deep_transform_values_to_percentages with relative: true" do
    it "returns an empty hash when the input hash is empty" do
      hash = {}
      expect(hash.deep_transform_values_to_percentages).to eq({})
    end

    it "calculates percentages for a flat hash" do
      hash = { a: 10, b: 30, c: 60 }
      expected = { a: 10.0, b: 30.0, c: 60.0 }

      expect(hash.deep_transform_values_to_percentages).to eq(expected)
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

      expect(hash.deep_transform_values_to_percentages(precision: 2)).to eq(expected)
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

      expect(hash.deep_transform_values_to_percentages(precision: 2)).to eq(expected)
    end

    it "returns raw percentages when precision is 2" do
      hash = { a: 10, b: { x: 10, y: 20 } }
      result = hash.deep_transform_values_to_percentages(precision: 2)

      expect(result[:a]).to eq(25.0)
      expect(result[:b][:x]).to eq(33.33)
      expect(result[:b][:y]).to eq(66.67)
    end

    it "returns raw percentages when precision is not provided" do
      hash = { a: 10, b: { x: 10, y: 20 } }
      result = hash.deep_transform_values_to_percentages

      expect(result[:a]).to eq(25.0)
      expect(result[:b][:x]).to be_within(0.0001).of(33.3333333333)
      expect(result[:b][:y]).to be_within(0.0001).of(66.6666666667)
    end

    it "handles hashes with zero values" do
      hash = { a: 0, b: 0, c: 0 }
      expect(hash.deep_transform_values_to_percentages).to eq({ a: 0.0, b: 0.0, c: 0.0 })
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

      expect(hash.deep_transform_values_to_percentages(precision: 2)).to eq(expected)
    end
  end
end
