require "rails_helper"

RSpec.describe "Job offer publication form", :type => :system do
  before do
    Timecop.freeze('2019-01-01')
  end

  after do
    Timecop.return
  end

  it 'allows to submit a job' do
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

    expect(page).to have_text("Ogłoszenie czeka na akceptację. Po akceptacji otrzymasz maila na adres marcin@rubyjobs.pl")
  end

  it 'shows job offer data on preview step' do
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

    expect(page).to have_text("Strona główna")
    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")
    expect(page).to have_xpath("//img[contains(@src,'logo.png')]")

    expect(page).to have_text("Treść ogłoszenia")
    expect(page).to have_text("Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia.")

    expect(page).to_not have_link("Accept")
    expect(page).to_not have_link("Reject")
  end

  it 'shows job offer data on publication step' do
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

    expect(page).to have_text("rubyjobs i spółka")
    expect(page).to have_text("Ruby on Rails Developer")
    expect(page).to have_text("Zdalnie")
    expect(page).to have_text("Warszawa")
    expect(page).to have_text("Białystok")
    expect(page).to have_text("11000 - 18000")
    expect(page).to have_text("B2B")
    expect(page).to have_xpath("//img[contains(@src,'logo.png')]")
  end

  it 'shows job publication info on publication step' do
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

    expect(page).to have_text("Informacje dodatkowe")
    expect(page).to have_text("będzie automatycznie przedłużone i odświeżone po 30 dniach")
    expect(page).to have_text("marcin@rubyjobs.pl")
  end

  describe 'moving back and forth with editing' do
    it 'moves back from preview step to adding new job step and keeps job information' do
      visit "/"
      click_link "Dodaj ogłoszenie"

      fill_in :job_offer_title, with: "Ruby on Rails Developer"
      fill_in :job_offer_city_names, with: "Warszawa, Białystok"
      check :job_offer_remote
      fill_in :job_offer_salary, with: "11000 - 18000"
      select "Umowa o pracę", from: :job_offer_salary_type
      find('trix-editor').click.set('Praca dla programisty Ruby on Rails, minimum 2 lata doświadczenia.')
      fill_in :job_offer_apply_link, with: "https://rubyjobs.pl/career/ruby_on_rails_developer"

      fill_in :job_offer_company_attributes_name, with: "rubyjobs i spółka"
      attach_file :job_offer_logo, "#{Rails.root}/spec/fixtures/files/logo.png"
      fill_in :job_offer_email, with: "marcin@rubyjobs.pl"

      click_button "Dalej"
      click_link "Dalej"
      click_link "Wstecz"
      click_link "Wstecz"

      expect(page).to have_field('job_offer_title', with: 'Ruby on Rails Developer')
      expect(page).to have_select('job_offer_salary_type', selected: 'Umowa o pracę')
      expect(page).to have_xpath("//img[contains(@src,'logo.png')]")

      fill_in :job_offer_title, with: "Junior Ruby on Rails Developer"
      uncheck :job_offer_remote

      click_button "Dalej"

      expect(page).to have_text('Junior Ruby on Rails Developer')
      expect(page).to_not have_text('Zdalnie')
    end
  end
end
