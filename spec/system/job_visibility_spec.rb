require "rails_helper"

RSpec.describe "Job offer visibility", :type => :system do
  describe 'when job offer is submitted' do
    describe 'when job offer is published' do
      it 'is visible for regular user' do
        create(
          :job_offer, 
          title: "RoR Developer", 
          submitted_at: Time.zone.now - 2.day,
          published_at: Time.zone.now - 1.day
        )
        user = create(:user, admin: false)

        visit "/users/sign_in"
        fill_in :user_email, with: user.email
        fill_in :user_password, with: user.password
        click_button "Log in" 

        visit "/"
        expect(page).to have_text("RoR Developer")
      end

      it 'is visible for admin' do
        create(
          :job_offer, 
          title: "RoR Developer", 
          submitted_at: Time.zone.now - 2.day,
          published_at: Time.zone.now - 1.day
        )
        user = create(:user, admin: true)

        visit "/users/sign_in"
        fill_in :user_email, with: user.email
        fill_in :user_password, with: user.password
        click_button "Log in" 

        visit "/"
        expect(page).to have_text("RoR Developer")

      end
    end

    describe 'when job offer is not published' do
      it 'is not visible for regular user' do
        create(
          :job_offer, 
          title: "RoR Developer", 
          submitted_at: Time.zone.now - 2.day,
          published_at: nil
        )
        user = create(:user, admin: false)

        visit "/users/sign_in"
        fill_in :user_email, with: user.email
        fill_in :user_password, with: user.password
        click_button "Log in" 

        visit "/"
        expect(page).to_not have_text("RoR Developer")
      end

      it 'is visible for admin' do
        create(
          :job_offer, 
          title: "RoR Developer", 
          submitted_at: Time.zone.now - 2.day,
          published_at: nil
        )
        user = create(:user, admin: true)

        visit "/users/sign_in"
        fill_in :user_email, with: user.email
        fill_in :user_password, with: user.password
        click_button "Log in" 

        visit "/"
        expect(page).to have_text("RoR Developer")
      end
    end
  end

  describe 'when job offer is not submitted' do
    it 'is not visible for regular user'
    it 'is not visible for admin'
  end
end
