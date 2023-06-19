# frozen_string_literal: true

require "spec_helper"

module Decidim
  module AccessCodes
    module Verification
      describe AuthorizationForm do
        subject { form }

        let(:organization) do
          create(:organization, available_authorizations: [verification_type])
        end

        let(:verification_type) { "ac_verification" }
        let(:handler_handle) { verification_type }
        let(:access_code) { create(:access_code, maximum_uses: maximum_uses, times_used: times_used, organization: organization) }
        let(:times_used) { 0 }
        let(:maximum_uses) { 0 }
        let(:code) { access_code.code }

        let(:params) do
          {
            handler_handle: handler_handle,
            code: code
          }
        end

        let(:form) do
          described_class.from_params(params).with_context(
            current_organization: organization
          )
        end

        context "when everything is OK" do
          it { is_expected.to be_valid }
        end

        context "with invalid handler handle" do
          let(:handler_handle) { "unexisting" }

          it { is_expected.to be_invalid }
        end

        context "with invalid code" do
          context "when code is not present" do
            let(:code) { nil }

            it { is_expected.to be_invalid }
          end

          context "when there is no maximum count defined" do
            let(:maximum_uses) { 0 }

            context "and it has been used many times" do
              let(:times_used) { 999 }

              it { is_expected.to be_valid }
            end
          end

          context "when there is a maximum use count defined" do
            let(:maximum_uses) { 2 }

            context "when code has not yet reached maximum use count" do
              let(:times_used) { 1 }

              it { is_expected.to be_valid }
            end

            context "when code has reached maximum use count" do
              let(:times_used) { 2 }

              it { is_expected.to be_invalid }
            end
          end
        end

        describe "#handler_name" do
          it { expect(form.handler_name).to eq(handler_handle) }
        end
      end
    end
  end
end
