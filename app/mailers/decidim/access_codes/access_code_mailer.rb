# frozen_string_literal: true

module Decidim
  module AccessCodes
    # This mailer sends an email with an access code for user verification
    class AccessCodeMailer < Decidim::ApplicationMailer
      include Decidim::TranslatableAttributes

      helper Decidim::TranslatableAttributes

      # Public: Sends a notification email with an access code for user verification
      #
      # access_code - The access code object containing the email and the code itself
      #
      # Returns nothing.
      def send_code(access_code)
        @access_code = access_code
        @organization = access_code.organization
        @authorize_url = decidim_access_codes.new_authorization_url(host: @organization.host)

        mail(
          to: @access_code.email,
          subject: I18n.t("decidim.access_codes.access_code_mailer.send_code.subject",
                          organization_name: translated_attribute(@organization.name))
        )
      end
    end
  end
end
