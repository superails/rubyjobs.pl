require "rails_helper"

RSpec.describe "Job offer details", :type => :system do
  let(:admin) { create(:user, admin: true) }

  it 'shows job_offer details' do
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

    visit "/users/sign_in"
    fill_in :user_email, with: admin.email
    fill_in :user_password, with: admin.password
    click_button "Login" 

    click_link "Accept"

    visit "/"
    click_link "Ruby on Rails Developer"

    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")
    expect(page).to have_text("Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia.")
    expect(page).to have_link("Aplikuj teraz", href: /redirect/)
  end
end

