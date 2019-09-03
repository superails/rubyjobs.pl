require "rails_helper"

RSpec.describe "Job publication form", :type => :system do
  before do
    driven_by(:selenium_chrome_headless)
    Timecop.freeze('2019-01-01')
  end

  after do
    Timecop.return
  end

  it 'allows to publish a job' do
    visit "/"
    click_link "Dodaj ogłoszenie"
    expect(page).to have_text("Informacje o stanowisku")
    expect(page).to have_text("Informacje o firmie")

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

    expect(page).to have_text("Strona główna")
    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")

    expect(page).to have_text("Treść ogłoszenia")
    expect(page).to have_text("Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia.")

    click_link "Dalej"

    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")

    expect(page).to have_text("Informacje dodatkowe")
    expect(page).to have_text("do 31.01.2019")
    expect(page).to have_text("marcin@rubyjobs.pl")

    click_link "Publikuj"

    expect(page).to have_text("Dodaj ogłoszenie")
    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")
    expect(page).to have_text("Ogłoszenie zostało opublikowane, informacje zostały wysłane na adres marcin@rubyjobs.pl")
  end

  it 'keeps information about job offer when moving back and forth'
end
