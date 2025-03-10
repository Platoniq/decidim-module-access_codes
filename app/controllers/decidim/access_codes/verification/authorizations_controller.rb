# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      class AuthorizationsController < Decidim::ApplicationController
        include Decidim::Verifications::Renewable

        helper_method :authorization

        before_action :authorization

        def new
          enforce_permission_to(:create, :authorization, authorization:)

          @form = AuthorizationForm.new(handler_handle: "access_codes").with_context(current_organization:)
        end

        def edit
          enforce_permission_to :create, :authorization, authorization:
        end

        def create
          enforce_permission_to(:create, :authorization, authorization:)

          @form = AuthorizationForm.from_params(
            params.merge(user: current_user)
          ).with_context(current_organization:)

          Decidim::AccessCodes::Verification::ConfirmUserAuthorization.call(authorization, @form, session) do
            on(:ok) do
              flash[:notice] = t("authorizations.create.success", scope: "decidim.access_codes.verification")
              redirect_to decidim_verifications.authorizations_path
            end

            on(:invalid) do
              flash.now[:alert] = t("authorizations.create.error", scope: "decidim.access_codes.verification")
              render :new
            end
          end
        end

        private

        def authorization
          @authorization ||= Decidim::Authorization.find_or_initialize_by(
            user: current_user,
            name: "access_codes"
          )
        end
      end
    end
  end
end
