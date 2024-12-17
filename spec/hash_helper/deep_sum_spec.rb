# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/hash_helper/deep_sum"

RSpec.describe HashHelper::DeepSum do
  it 'returns 0 for an empty hash' do
    expect({}.deep_sum).to eq(0)
  end

  it 'returns the sum of top-level numeric values' do
    data = { a: 1, b: 2, c: 3 }
    expect(data.deep_sum).to eq(6)
  end

  it 'handles nested hashes' do
    data = { a: 1, b: { c: 2, d: { e: 3, f: 4 } } }
    expect(data.deep_sum).to eq(10)
  end

  it 'handles arrays within hashes' do
    data = { a: 1, b: [2, 3, 4] }
    expect(data.deep_sum).to eq(10)
  end

  it 'handles arrays containing nested hashes' do
    data = { a: 1, b: [2, { c: 3, d: 4 }] }
    expect(data.deep_sum).to eq(10)
  end

  it 'handles deeply nested hashes and arrays' do
    data = {
      a: 1,
      b: { c: 2, d: { e: 3, f: 4 } },
      g: [5, { h: 6, i: { j: 7 } }]
    }
    expect(data.deep_sum).to eq(28)
  end

  it 'ignores non-numeric values' do
    data = { a: 'hello', b: 1, c: [2, 'world', { d: 3 }] }
    expect(data.deep_sum).to eq(6)
  end

  it 'returns 0 if no numeric values are present' do
    data = { a: 'hello', b: 'world', c: [nil, 'test'] }
    expect(data.deep_sum).to eq(0)
  end
end
