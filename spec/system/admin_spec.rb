# frozen_string_literal: true

require "spec_helper"

describe "Visit the admin page" do
  let(:available_authorizations) { %w(access_codes) }
  let(:organization) { create(:organization, available_authorizations:) }
  let!(:admin) { create(:user, :admin, :confirmed, organization:) }

  before do
    switch_to_host(organization.host)
    login_as admin, scope: :user

    visit decidim_admin.root_path

    click_on "Participants"
    click_on "Authorizations"
  end

  # rubocop:disable RSpec/InstanceVariable
  describe "manages access codes" do
    let(:code_name) { "first_code" }
    let(:email) { "foo@example.org" }

    before do
      # Create an existing access code and a granted authorization for a user using that access code
      @access_code = create(:access_code, organization:)
      @authorization = create(:authorization, :granted, name: "access_codes", user: admin, metadata: {
                                "access_code_id" => @access_code.id,
                                "code" => @access_code.code,
                                "name" => @access_code.name,
                                "email" => @access_code.email
                              })

      within(".table-list") do
        click_on "Access codes"
      end
    end

    context "when there are existing access codes and authorizations" do
      it "displays existing access codes" do
        expect(page).to have_content "Access codes"
        expect(page).to have_content @access_code.email
      end

      it "displays existing access code authorizations" do
        page.find(".table-list__actions .action-icon--users").click

        expect(page).to have_content "Access code"
        expect(page).to have_content "Users verified with this code"
        expect(page).to have_content admin.nickname
      end

      it "can remove an access code authorization for a user" do
        page.find(".table-list__actions .action-icon--delete").click

        expect(page).to have_content "Access code was deleted successfully"
        expect(page).to have_no_content admin.nickname
      end

      it "can remove and access code" do
        page.find(".table-list__actions .action-icon--delete").click

        expect(page).to have_content "Access code was deleted successfully"
        expect(page).to have_no_content @access_code.email
      end
    end

    # rubocop:enable RSpec/InstanceVariable

    context "when creating a new access code" do
      it "can create and send a new access code" do
        click_on "Create access codes"

        expect(page).to have_content "Send access codes"

        fill_in "access_code_data", with: "#{code_name};#{email}"
        click_on "Send codes"

        expect(page).to have_content "Access codes"
        expect(page).to have_content code_name
        expect(page).to have_content email
      end
    end
  end
end
