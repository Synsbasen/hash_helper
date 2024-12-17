# frozen_string_literal: true

require_relative "hash_helper/version"

module HashHelper
  require_relative "hash_helper/deep_invert"
  require_relative "hash_helper/deep_normalize"
end

class Hash
  include HashHelper::DeepInvert
  include HashHelper::DeepNormalize
end
