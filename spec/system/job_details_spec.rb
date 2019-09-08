require "rails_helper"

RSpec.describe "Job details", :type => :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'shows job details' do
    visit "/"
    click_link "Dodaj ogłoszenie"

    fill_in :job_title, with: "Ruby on Rails Developer"
    fill_in :job_location, with: "Warszawa, Białystok"
    check :job_remote
    fill_in :job_salary, with: "11000 - 18000"
    select "B2B", from: :job_salary_type
    fill_in :job_description, with: "Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia."
    fill_in :job_apply_link, with: "https://rubyjobs.pl/career/ruby_on_rails_developer"

    fill_in :job_company_attributes_name, with: "rubyjobs i spółka"
    attach_file :job_company_attributes_logo, "#{Rails.root}/spec/fixtures/files/logo.png"
    fill_in :job_email, with: "marcin@rubyjobs.pl"

    click_button "Dalej"
    click_link "Dalej"
    click_link "Publikuj"

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
    expect(page).to have_link("Aplikuj teraz", href: "https://rubyjobs.pl/career/ruby_on_rails_developer")
  end
end

