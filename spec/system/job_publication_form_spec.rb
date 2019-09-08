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

  it 'shows job offer data on preview step' do
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
  end

  it 'shows job offer data on publication step' do
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

    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")
  end

  it 'shows job publication info on publication step' do
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

    expect(page).to have_text("Informacje dodatkowe")
    expect(page).to have_text("do 31.01.2019")
    expect(page).to have_text("marcin@rubyjobs.pl")
  end

  describe 'moving back and forth with editing' do
    it 'moves back from preview step to adding new job step and keeps job information' do
      visit "/"
      click_link "Dodaj ogłoszenie"

      fill_in :job_title, with: "Ruby on Rails Developer"
      fill_in :job_location, with: "Warszawa, Białystok"
      check :job_remote
      fill_in :job_salary, with: "11000 - 18000"
      select "Umowa o pracę", from: :job_salary_type
      fill_in :job_description, with: "Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia."
      fill_in :job_apply_link, with: "https://rubyjobs.pl/career/ruby_on_rails_developer"

      fill_in :job_company_attributes_name, with: "rubyjobs i spółka"
      attach_file :job_company_attributes_logo, "#{Rails.root}/spec/fixtures/files/logo.png"
      fill_in :job_email, with: "marcin@rubyjobs.pl"

      click_button "Dalej"
      click_link "Dalej"
      click_link "Wstecz"
      click_link "Wstecz"

      expect(page).to have_field('job_title', with: 'Ruby on Rails Developer')
      expect(page).to have_select('job_salary_type', selected: 'Umowa o pracę')

      fill_in :job_title, with: "Senior Ruby on Rails Developer"
      uncheck :job_remote

      click_button "Dalej"

      expect(page).to have_text('Senior Ruby on Rails Developer')
      expect(page).to_not have_text('Zdalnie')
    end
  end
end
