# frozen_string_literal: true

module Decidim
  module AccessCodes
    module Verification
      # This is an engine that performs user authorization.
      class Engine < ::Rails::Engine
        isolate_namespace Decidim::AccessCodes::Verification

        routes do
          resource :authorizations, only: [:new, :create, :edit], as: :authorization do
            get :renew, on: :collection
          end

          root to: "authorizations#new"
        end

        initializer "decidim_notify.webpacker.assets_path" do
          Decidim.register_assets_path File.expand_path("app/packs", root)
        end

        def load_seed
          # Enable the `:access_codes` authorization
          org = Decidim::Organization.first
          org.available_authorizations << :access_codes
          org.save!
        end
      end
    end
  end
end
