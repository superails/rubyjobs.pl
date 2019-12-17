require "rails_helper"

RSpec.describe "Job offer search", :type => :system do
  it 'shows job offers with search term in location, title or description' do
    create(:job_offer, state: 'published', city_names: 'Warszawa, Białystok', remote: '1', title: 'Junior RoR Dev')
    create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev (zdalnie)')
    create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'Senior RoR Dev', description: 'Pracuj zdalnie')
    create(:job_offer, state: 'published', city_names: 'Warszawa', title: 'Elixir Dev', remote: '0')
    create(:job_offer, state: 'published', city_names: 'Warszawa', remote: '0', title: 'RoR Dev', company_attributes: { name: 'Zdalnie Sp.z o.o' })


    visit "/"
    fill_in :q, with: 'Zdalnie'
    click_button 'Szukaj'

    expect(page).to have_text 'Junior RoR Dev'
    expect(page).to have_text 'RoR Dev (zdalnie)'
    expect(page).to have_text 'Zdalnie Sp.z o.o'
    expect(page).to_not have_text 'Senior RoR Dev'
    expect(page).to_not have_text 'Elixir Dev'
  end
end

