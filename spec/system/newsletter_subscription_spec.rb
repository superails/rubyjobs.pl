require "rails_helper"

RSpec.describe "Newsletter subscription", :type => :system do
  it 'shows weekly newsletter box' do
    create(
      :job_offer, 
      title: "RoR Developer", 
      state: 'published',
      submitted_at: Time.zone.now - 2.day,
      published_at: Time.zone.now - 1.day
    )

    visit '/'

    expect(page).to have_text 'Przegląd ofert'
  end

  describe 'when user signs up to newsletter' do
    it 'shows thank you flash message' do
      create(
        :job_offer, 
        title: "RoR Developer", 
        state: 'published',
        submitted_at: Time.zone.now - 2.day,
        published_at: Time.zone.now - 1.day
      )

      visit '/'

      fill_in :email, with: 'marcin@rubyjobs.pl'

      click_button 'Zapisz się'

      expect(page).to have_text 'Dziękuję za zapisanie się, wkrótce powinieneś otrzymać maila z potwierdzeniem.'
    end

    it 'does not show weekly newsletter box' do
      create(
        :job_offer, 
        title: "RoR Developer", 
        state: 'published',
        submitted_at: Time.zone.now - 2.day,
        published_at: Time.zone.now - 1.day
      )

      visit '/'

      fill_in :email, with: 'marcin@rubyjobs.pl'

      click_button 'Zapisz się'

      expect(page).to_not have_text 'Przegląd ofert'
    end
  end

  describe 'when no job offers' do
    it 'does not show weekly newsletter box' do
      visit '/'

      expect(page).to_not have_text 'Przegląd ofert'
    end
  end

  describe 'confirmation' do
    it 'shows thank you flash message' do
      create(:newsletter_subscription, email: 'marcin@rubyjobs.pl', confirm_token: '123')

      visit '/newsletter_subscriptions/123/confirm'

      expect(page).to have_text 'Dziękuję za potwierdzenie subskrypcji.'
    end
  end
end

