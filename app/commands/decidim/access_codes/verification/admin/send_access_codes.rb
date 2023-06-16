# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      module Admin
        # ...
        class SendAccessCodes < Decidim::Command
          SEPARATOR = ";"

          # Public: Initializes the command.
          #
          # form - A form object with the emails to send access codes to.
          def initialize(form)
            @form = form
          end

          # Executes the command. Broadcasts these events:
          #
          # - :ok when everything is valid.
          # - :invalid if the form wasn't valid and we couldn't proceed.
          #
          # Returns nothing.
          def call
            return broadcast(:invalid) if @form.invalid?

            @form.data.each_line { |data_line| create_access_code(data_line) }

            broadcast(:ok)
          end

          private

          attr_reader :form

          delegate :organization, to: :form

          def create_access_code(data_line)
            name, email = data_line.split(SEPARATOR).map(&:strip)

            access_code = Decidim::AccessCodes::AccessCode.create!(
              organization: organization,
              name: name,
              email: email
            )

            Decidim::AccessCodes::AccessCodeMailer.send_code(access_code).deliver_later
          end
        end
      end
    end
  end
end
