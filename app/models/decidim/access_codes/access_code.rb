# frozen_string_literal: true

module Decidim
  module AccessCodes
    class AccessCode < ApplicationRecord
      class AccessCodeError < StandardError; end
      self.table_name = :decidim_access_codes_access_codes

      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

      before_save :generate, :set_maximum_uses

      validates :email, presence: true, "valid_email_2/email": { disposable: true }
      validates :code, uniqueness: { scope: :decidim_organization_id }, if: -> { code.present? }

      before_destroy :destroy_authorizations

      def use!
        return raise AccessCodeError, "Code used too many times" unless usable?

        increment(:times_used)
        save!
      end

      def usable?
        return true unless maximum_uses.positive?

        times_used < maximum_uses
      end

      def self.length
        Decidim::AccessCodes.config.access_code_length || 8
      end

      def authorizations
        Decidim::Authorization.select { |auth| auth.metadata["access_code_id"] == id }
      end

      private

      def destroy_authorizations
        authorizations.each(&:destroy)
      end

      def generate
        return if code.present?

        loop do
          digest = "#{email}-#{organization.id}-#{Rails.application.secrets.secret_key_base}"
          self.code = Decidim::Tokenizer.new(length: AccessCode.length).hex_digest(digest)
          if AccessCode.find_by(code:).blank?
            save!
            break
          end
        end
      end

      def set_maximum_uses
        return if maximum_uses.present?

        update(maximum_uses: Decidim::AccessCodes.config.default_maximum_use_count)
      end
    end
  end
end
