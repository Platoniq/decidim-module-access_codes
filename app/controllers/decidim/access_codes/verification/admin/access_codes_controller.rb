# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      module Admin
        class AccessCodesController < Decidim::Admin::ApplicationController
          helper_method :access_code, :access_codes, :authorizations, :paginated_authorizations
          delegate :authorizations, to: :access_code

          def index
            enforce_permission_to :index, :authorization
          end

          def show
            enforce_permission_to :read, :authorization
          end

          def new
            enforce_permission_to :create, :authorization

            @form = AccessCodeForm.new
          end

          def create
            enforce_permission_to :create, :authorization

            @form = AccessCodeForm.from_params(params).with_context(current_organization:)

            Decidim::AccessCodes::Verification::Admin::SendAccessCodes.call(@form) do
              on(:ok) do
                flash[:notice] = t("access_codes.create.success", scope: "decidim.access_codes.verification.admin")
                redirect_to access_codes_path
              end

              on(:invalid) do
                flash.now[:alert] = t("access_codes.create.error", scope: "decidim.access_codes.verification.admin")
                render :new
              end
            end
          end

          def destroy
            enforce_permission_to :destroy, :authorization

            DestroyAccessCode.call(access_code) do
              on(:ok) do
                flash[:notice] = t("access_codes.destroy.success", scope: "decidim.access_codes.verification.admin")
                redirect_to access_codes_path
              end

              on(:invalid) do
                flash[:alert] = t("access_codes.destroy.error", scope: "decidim.access_codes.verification.admin")
                redirect_to access_codes_path
              end
            end
          end

          private

          def access_code
            @access_code ||= AccessCode.find(params[:id])
          end

          def access_codes
            @access_codes ||= AccessCode.where(organization: current_organization).page(params[:page]).per(15)
          end

          def paginated_authorizations
            @paginated_authorizations ||= Decidim::Authorization.where(id: authorizations.map(&:id)).page(params[:page]).per(15)
          end
        end
      end
    end
  end
end
