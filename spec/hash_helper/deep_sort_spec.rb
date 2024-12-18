# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/hash_helper/deep_sort"

RSpec.describe "HashHelper::DeepSort" do
  describe "#deep_sort" do
    it "sorts flat hashes lexicographically by keys" do
      hash = { "b" => 1, "a" => 2, "c" => 3 }
      sorted = hash.deep_sort
      expect(sorted).to eq({ "a" => 2, "b" => 1, "c" => 3 })
    end

    it "recursively sorts nested hashes lexicographically" do
      hash = { "b" => { "d" => 2, "c" => 1 }, "a" => { "e" => 3, "f" => 4 } }
      sorted = hash.deep_sort
      expect(sorted).to eq({
        "a" => { "e" => 3, "f" => 4 },
        "b" => { "c" => 1, "d" => 2 }
      })
    end
  end

  describe "#deep_sort_by" do
    context "when sorting a flat hash" do
      it "sorts by key lexicographically by default" do
        hash = { "b" => 1, "a" => 2, "null" => 3 }
        sorted = hash.deep_sort_by { |key, _value| key }
        expect(sorted).to eq({ "a" => 2, "b" => 1, "null" => 3 })
      end

      it "sorts by value" do
        hash = { "a" => 3, "b" => 1, "c" => 2 }
        sorted = hash.deep_sort_by { |_key, value| value }
        expect(sorted).to eq({ "b" => 1, "c" => 2, "a" => 3 })
      end

      it "places the 'null' key at the end based on custom logic" do
        hash = { "null" => 3, "a" => 1, "b" => 2 }
        sorted = hash.deep_sort_by { |key, _value| key == "null" ? 1 : 0 }
        expect(sorted).to eq({ "a" => 1, "b" => 2, "null" => 3 })
      end

      it "sorts keys numerically if custom logic converts keys to integers" do
        hash = { "10" => 1, "2" => 2, "null" => 3 }
        sorted = hash.deep_sort_by { |key, _value| key == "null" ? Float::INFINITY : key.to_i }
        expect(sorted).to eq({ "2" => 2, "10" => 1, "null" => 3 })
      end
    end

    context "when sorting a nested hash" do
      it "recursively sorts keys in nested hashes by key" do
        hash = { "b" => { "d" => 2, "c" => 1 }, "a" => { "null" => 3, "e" => 4 } }
        sorted = hash.deep_sort_by { |key, _value| key }
        expect(sorted).to eq({
          "a" => { "e" => 4, "null" => 3 },
          "b" => { "c" => 1, "d" => 2 }
        })
      end

      it "recursively sorts by value in nested hashes" do
        hash = { "b" => { "c" => 2, "d" => 1 }, "a" => { "e" => 3, "null" => 4 } }
        sorted = hash.deep_sort_by { |_key, value| value }
        expect(sorted).to eq({
          "b" => { "d" => 1, "c" => 2 },
          "a" => { "e" => 3, "null" => 4 }
        })
      end

      it "places 'null' keys at the end in nested hashes" do
        hash = { "null" => 1, "a" => { "null" => 3, "b" => 2 } }
        sorted = hash.deep_sort_by { |key, _value| key == "null" ? 1 : 0 }
        expect(sorted).to eq({
          "a" => { "b" => 2, "null" => 3 },
          "null" => 1
        })
      end
    end

    context "edge cases" do
      it "returns an empty hash when the input is empty" do
        hash = {}
        sorted = hash.deep_sort_by { |key, _value| key }
        expect(sorted).to eq({})
      end

      it "handles hashes with non-string keys" do
        hash = { b: 1, a: 2, null: 3 }
        sorted = hash.deep_sort_by { |key, _value| key.to_s }
        expect(sorted).to eq({ a: 2, b: 1, null: 3 })
      end

      it "handles hashes with non-hash values" do
        hash = { "a" => 1, "b" => [1, 2], "c" => "string" }
        sorted = hash.deep_sort_by { |key, _value| key }
        expect(sorted).to eq({ "a" => 1, "b" => [1, 2], "c" => "string" })
      end
    end
  end
end
