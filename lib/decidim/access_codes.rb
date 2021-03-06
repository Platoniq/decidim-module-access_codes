# frozen_string_literal: true

require_relative "access_codes/version"
require_relative "access_codes/verification"

module Decidim
  module AccessCodes
    include ActiveSupport::Configurable

    config_accessor :default_maximum_use_count do
      10
    end

    config_accessor :access_code_length do
      8
    end
  end
end
