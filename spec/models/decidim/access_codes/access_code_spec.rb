# frozen_string_literal: true

require "spec_helper"

module Decidim::AccessCodes
  describe AccessCode do
    subject { access_code }

    let(:organization) { create(:organization) }
    let(:access_code) { create(:access_code, organization:) }

    it { is_expected.to be_valid }

    it "is associated with an organization" do
      expect(subject).to eq(access_code)
      expect(subject.organization).to eq(organization)
    end

    it "generates a codes and sets the maximum uses" do
      expect(subject.code).to be_present
      expect(subject.code).to match(/[0-9a-fA-F]{#{Decidim::AccessCodes.config.access_code_length}}/)
      expect(subject.organization).to eq(organization)
    end
  end
end
