require "rails_helper"

RSpec.describe "Job publication form errors", :type => :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'shows error messages' do
    visit "/"
    click_link "Dodaj ogłoszenie"

    fill_in :job_offer_title, with: ""
    fill_in :job_offer_city_names, with: ""
    fill_in :job_offer_salary, with: ""
    fill_in :job_offer_description, with: ""
    fill_in :job_offer_apply_link, with: ""

    fill_in :job_offer_company_attributes_name, with: ""
    fill_in :job_offer_email, with: ""

    click_button "Dalej"

    expect(page).to have_text("nie może być puste")
    expect(page).to have_text("jest nieprawidłowe")
  end
end
