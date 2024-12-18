# HashHelper Gem

`HashHelper` is a versatile Ruby gem providing powerful utility modules for deeply nested hashes. It simplifies common operations such as deep inversion, normalization, summation, percentage calculations, and converting arrays into nested hash structures. This gem automatically extends `Hash` and `Array` with the provided methods, allowing you to seamlessly manipulate nested data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash_helper'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install hash_helper
```

## Features

### 1. DeepInvert

Deeply inverts a hash, reversing the nesting structure.

**Example:**

```ruby
hash = { a: { b: { c: 1 } }, d: { e: 2 } }
inverted = hash.deep_invert
# Result: { c: { b: { a: 1 } }, e: { d: 2 } }
```

---

### 2. DeepNormalize

Recursively normalizes a hash by ensuring all layers in the nested structure contain the same keys, merging it with a default structure to fill in any missing keys or values.

**Example:**

```ruby
hash = { a: { x: 1, y: 2 }, b: { z: 3 } }
normalized = hash.deep_normalize(default_value: 0)
# Result: { a: { x: 1, y: 2, z: 0 }, b: { x: 0, y: 0, z: 3 } }
```

---

### 3. DeepSum

Calculates the sum of all numeric values in a nested hash or array.

**Example:**

```ruby
hash = {
  a: 1,
  b: { c: 2, d: { e: 3, f: 4 } },
  g: [5, { h: 6, i: { j: 7 } }]
}
result = hash.deep_sum
# Result: 28
```

---

### 4. Percentage

Transforms numeric values in a hash into percentages relative to a layer or the entire structure.

**Example:**

```ruby
hash = { a: 50, b: { c: 30, d: 20 }, e: 100 }

# Global percentages
percentages = hash.deep_transform_values_to_percentages(relative: false)
# Result: { a: 25.0, b: { c: 15.0, d: 10.0 }, e: 50.0 }

# Relative percentages
relative_percentages = hash.deep_transform_values_to_percentages(relative: true)
# Result: { a: 50.0, b: { c: 60.0, d: 40.0 }, e: 100.0 }
```

---

### 5. ToNestedH

Converts a nested array into a nested hash with a default value at leaf nodes.

**Example:**

```ruby
nested_array = [[:a, :b], [:x, :y], [:m, :n]]
nested_hash = nested_array.to_nested_h(value: "leaf")
# Result:
# {
#   a: { x: { m: "leaf", n: "leaf" }, y: { m: "leaf", n: "leaf" } },
#   b: { x: { m: "leaf", n: "leaf" }, y: { m: "leaf", n: "leaf" } }
# }
```

## Usage

The gem automatically extends `Hash` and `Array` with the provided methods. You can use them directly:

```ruby
require 'hash_helper'

hash = { a: { b: { c: 1 } } }
puts hash.deep_invert
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/Synsbasen/hash\_helper](https://github.com/Synsbasen/hash_helper).

## License

The gem is available as open-source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
