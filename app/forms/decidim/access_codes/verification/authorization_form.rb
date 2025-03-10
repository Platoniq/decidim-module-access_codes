# frozen_string_literal: true

require "securerandom"

module Decidim
  module AccessCodes
    module Verification
      # A form object for users to enter their access code to get verified.
      class AuthorizationForm < AuthorizationHandler
        attribute :code, String
        attribute :handler_handle, String

        validate :valid_code?

        validates :code, presence: true

        validates :handler_handle,
                  presence: true,
                  inclusion: {
                    in: proc { |form|
                      form.current_organization.available_authorizations
                    }
                  }

        def handler_name
          handler_handle
        end

        def access_code
          Decidim::AccessCodes::AccessCode.find_by(organization: current_organization, code:)
        end

        private

        def valid_code?
          errors.add(:code, :invalid) unless access_code&.usable?
        end
      end
    end
  end
end
