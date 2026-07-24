# frozen_string_literal: true

require_relative "access_codes/version"
require_relative "access_codes/verification"

module Decidim
  module AccessCodes
    class << self
      def config = self

      def configure
        yield self
      end
    end

    mattr_accessor :default_maximum_use_count, default: 10
    mattr_accessor :access_code_length, default: 8
  end
end
