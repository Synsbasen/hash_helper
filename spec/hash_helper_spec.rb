# frozen_string_literal: true

RSpec.describe HashHelper do
  it "has a version number" do
    expect(HashHelper::VERSION).not_to be nil
  end

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

  describe "#deep_invert" do
    it "inverts a hash with two layers" do
      hash = { a: { x: 1 }, b: { x: 2, y: 3 }, c: { x: 3 } }
      inverted_hash = hash.deep_invert

      expected_result = {
        x: { a: 1, b: 2, c: 3 },
        y: { b: 3 }
      }

      expect(inverted_hash).to eq(expected_result)
    end

    it "handles an empty hash" do
      hash = {}
      inverted_hash = hash.deep_invert

      expect(inverted_hash).to eq({})
    end

    it "handles a deeply nested hash" do
      hash = { a: { x: { foo: 1 } }, b: { x: { foo: 2, bar: 3 } }, c: { x: { foo: 3 } } }
      inverted_hash = hash.deep_invert

      expected_result = {
        foo: { x: { a: 1, b: 2, c: 3 } },
        bar: { x: { b: 3 } }
      }

      expect(inverted_hash).to eq(expected_result)
    end

    context "double inversion" do
      it "returns the original hash for a simple example" do
        hash = { a: { x: 1 }, b: { y: 2 } }
        expect(hash.deep_invert.deep_invert).to eq(hash)
      end

      it "returns the original hash for a moderate example" do
        hash = {
          a: { x: 1, y: 2 },
          b: { x: 4, y: 5 },
          c: { z: 3 }
        }
        expect(hash.deep_invert.deep_invert).to eq(hash)
      end

      it "returns the original hash for a complex nested example" do
        hash = {
          a: { x: { foo: 1, bar: 2 }, y: { baz: 3 } },
          b: { x: { foo: 4 }, y: { baz: 5, qux: 6 } },
          c: { z: { foo: 7, qux: 8 } }
        }

        expect(hash.deep_invert.deep_invert).to eq(hash)
      end

      it "returns the original hash for an edge case with nil values" do
        hash = {
          a: { x: 1, y: nil },
          b: { x: nil, y: 2 }
        }
        expect(hash.deep_invert.deep_invert).to eq(hash)
      end

      it "returns the original hash for an edge case with empty sub-hashes" do
        hash = {
          a: {},
          b: { x: 1 },
          c: {}
        }
        expect(hash.deep_invert.deep_invert).to eq(hash)
      end
    end
  end
end
