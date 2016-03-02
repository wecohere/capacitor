require "rails_helper"

feature "Creating activities" do
  include_context "account login"

  When { click_link_or_button "Create a new activity" }
  When { fill_in "Name", with: "Activity A" }
  When { fill_in "Capacity", with: 10 }
  When { fill_in "Weekly burn rate", with: 5 }
  When { click_link_or_button "Create activity" }

  Then { expect(current_account.activities.find_by(name: "Activity A")).to be_persisted }
end