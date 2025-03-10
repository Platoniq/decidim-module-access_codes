# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      module Admin
        class AuthorizationsController < Decidim::Admin::ApplicationController
          def destroy
            enforce_permission_to(:destroy, :authorization, authorization:)

            access_code_id = authorization.metadata["access_code_id"]

            DestroyAuthorization.call(authorization) do
              on(:ok) do
                flash[:notice] = t("authorizations.destroy.success", scope: "decidim.access_codes.verification.admin")
                redirect_to access_code_path(access_code_id)
              end

              on(:invalid) do
                flash[:alert] = t("authorizations.destroy.error", scope: "decidim.access_codes.verification.admin")
                redirect_to access_code_path(access_code_id)
              end
            end
          end

          private

          def authorization
            @authorization ||= Authorization.find_by(
              id: params[:id],
              name: "access_codes"
            )
          end
        end
      end
    end
  end
end
