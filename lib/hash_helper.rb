# frozen_string_literal: true

require_relative "hash_helper/version"
require_relative "hash_helper/deep_sum"
require_relative "hash_helper/deep_invert"
require_relative "hash_helper/deep_normalize"
require_relative "hash_helper/percentage"

module HashHelper
end

class Hash
  include HashHelper::DeepSum
  include HashHelper::DeepInvert
  include HashHelper::DeepNormalize
  include HashHelper::Percentage
end
