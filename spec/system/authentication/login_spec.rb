require 'rails_helper'

RSpec.describe "Authentication", type: :system do
  describe "login" do
    let(:user) { create(:user) }

    before { user }

    it "redirects to dashboard after successful login" do
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_button "Log in"

      expect(page).to have_current_path(root_path)
      expect(page).to have_text("Signed in successfully")
    end

    it "shows error on invalid credentials" do
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: "wrong_password"
      click_button "Log in"

      expect(page).to have_text("Invalid email or password.")
    end
  end
end
