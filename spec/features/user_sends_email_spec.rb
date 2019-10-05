require "rails_helper"

RSpec.feature 'User sends an email' do
  scenario 'User creates a new email with valid inputs for all fields' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'
    fill_in 'email_email', :with => 'jon@test.com'
    fill_in 'email_phone_number', :with => '1231231234'
    find('#email_message_trix_input_email', visible: false).set('Testing')

    click_button "Submit"
    expect(page).to have_text("Your email has been sent")
  end

  scenario 'User creates a new email with valid inputs for all fields except phone number' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'
    fill_in 'email_email', :with => 'jon@test.com'
    find('#email_message_trix_input_email', visible: false).set('Testing')

    click_button "Submit"
    expect(page).to have_text("Your email has been sent")
  end

  scenario 'User creates a new email without valid inputs' do
    visit contact_path

    click_button "Submit"
    expect(page).to have_text("Please fix the following 3 errors")
  end

  scenario 'User creates a new email with one invalid input' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'
    fill_in 'email_email', :with => 'jon@test.com'
    fill_in 'email_phone_number', :with => '1231231234'

    click_button "Submit"

    expect(page).to have_text("Please fix the following 1 error:")
  end
end
