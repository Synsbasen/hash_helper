module HashHelper
  module ToNestedH
    # Converts a nested array into a nested hash with a default value at leaf nodes.
    # Each array in the input represents a level of keys in the resulting hash.
    #
    # @param [Object] value The default value to assign to the leaf nodes (default: nil).
    # @return [Hash] A nested hash structure with the specified default value at the leaves.
    #
    # @example Single level array
    #   [[:a, :b]].to_nested_h
    #   # => {:a => nil, :b => nil}
    #
    # @example Two levels of nesting
    #   [[:a, :b], [:x, :y]].to_nested_h(value: 0)
    #   # => {:a => {:x => 0, :y => 0}, :b => {:x => 0, :y => 0}}
    #
    # @example Multiple levels of nesting
    #   [[:a, :b], [:x, :y], [:m, :n]].to_nested_h(value: "leaf")
    #   # => {
    #   #   :a => { :x => { :m => "leaf", :n => "leaf" }, :y => { :m => "leaf", :n => "leaf" } },
    #   #   :b => { :x => { :m => "leaf", :n => "leaf" }, :y => { :m => "leaf", :n => "leaf" } }
    #   # }
    def to_nested_h(value: nil)
      return {} if empty?
      return first.product([value]).to_h if size == 1

      first.map do |key|
        [key, self[1..].to_nested_h(value: value)]
      end.to_h
    end
  end
end
