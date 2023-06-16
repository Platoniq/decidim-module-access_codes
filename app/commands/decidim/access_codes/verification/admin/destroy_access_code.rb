# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      module Admin
        # A command to destroy an access_code.
        class DestroyAccessCode < Decidim::Command
          # Public: Initializes the command.
          #
          # access_code - The access_code object to destroy.
          def initialize(access_code)
            @access_code = access_code
          end

          # Executes the command. Broadcasts these events:
          #
          # - :ok when everything is valid.
          # - :invalid if the access_code couldn't be destroyed.
          #
          # Returns nothing.
          def call
            return broadcast(:invalid) unless access_code

            destroy_access_code
            broadcast(:ok)
          end

          private

          attr_reader :access_code

          def destroy_access_code
            access_code.destroy!
          end
        end
      end
    end
  end
end
