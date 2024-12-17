# frozen_string_literal: true

require "spec_helper"
require "active_support/core_ext/hash/deep_merge"
require_relative "../../lib/hash_helper/to_nested_h"

RSpec.describe "HashHelper::ToNestedH" do
  describe '#to_nested_h' do
    it 'converts a single level array into a flat hash with default nil values' do
      arr = [[:a, :b]]
      expect(arr.to_nested_h).to eq({ a: nil, b: nil })
    end

    it 'converts a single level array with a custom default value' do
      arr = [[:a, :b]]
      expect(arr.to_nested_h(value: 0)).to eq({ a: 0, b: 0 })
    end

    it 'handles two levels of nesting' do
      arr = [[:a, :b], [:x, :y]]
      expected = { a: { x: nil, y: nil }, b: { x: nil, y: nil } }
      expect(arr.to_nested_h).to eq(expected)
    end

    it 'handles two levels of nesting with a custom default value' do
      arr = [[:a, :b], [:x, :y]]
      expected = { a: { x: 0, y: 0 }, b: { x: 0, y: 0 } }
      expect(arr.to_nested_h(value: 0)).to eq(expected)
    end

    it 'handles three levels of nesting' do
      arr = [[:a, :b], [:x, :y], [:m, :n]]
      expected = {
        a: { x: { m: nil, n: nil }, y: { m: nil, n: nil } },
        b: { x: { m: nil, n: nil }, y: { m: nil, n: nil } }
      }
      expect(arr.to_nested_h).to eq(expected)
    end

    it 'handles three levels of nesting with a custom default value' do
      arr = [[:a, :b], [:x, :y], [:m, :n]]
      expected = {
        a: { x: { m: 'leaf', n: 'leaf' }, y: { m: 'leaf', n: 'leaf' } },
        b: { x: { m: 'leaf', n: 'leaf' }, y: { m: 'leaf', n: 'leaf' } }
      }
      expect(arr.to_nested_h(value: 'leaf')).to eq(expected)
    end

    it 'returns an empty hash when the array is empty' do
      arr = []
      expect(arr.to_nested_h).to eq({})
    end
  end
end
