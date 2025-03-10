# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :access_code, class: "Decidim::AccessCodes::AccessCode" do
    organization { create(:organization) } # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
    email { Faker::Internet.email }
    code { Faker::Number.unique.hexadecimal(digits: 8) }
  end
end
