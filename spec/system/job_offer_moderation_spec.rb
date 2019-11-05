require "rails_helper"

RSpec.describe "Job offer moderation", :type => :system do
  let(:user) { create(:user, admin: true) }

  before :each do
    visit "/"
    click_link "Dodaj ogłoszenie"

    fill_in :job_offer_title, with: "Ruby on Rails Developer"
    fill_in :job_offer_city_names, with: "Warszawa, Białystok"
    check :job_offer_remote
    fill_in :job_offer_salary, with: "11000 - 18000"
    select "B2B", from: :job_offer_salary_type
    find('trix-editor').click.set('Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia.')
    fill_in :job_offer_apply_link, with: "https://rubyjobs.pl/career/ruby_on_rails_developer"

    fill_in :job_offer_company_attributes_name, with: "rubyjobs i spółka"
    attach_file :job_offer_logo, "#{Rails.root}/spec/fixtures/files/logo.png"
    fill_in :job_offer_email, with: "marcin@rubyjobs.pl"

    click_button "Dalej"
    click_link "Dalej"
    click_link "Wyślij"
  end

  it 'allows to accept job offer' do
    visit "/users/sign_in"

    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button "Login" 

    visit "/"
    click_link "Accept"

    expect(page).to have_text "Ruby on Rails Developer"
    expect(page).to_not have_link "Accept" 
  end

  it 'allows to reject job offer' do
    visit "/users/sign_in"
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button "Login" 

    visit "/"
    click_link "Reject"

    expect(page).to_not have_text "Ruby on Rails Developer"
  end
end

