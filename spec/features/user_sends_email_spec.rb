require "rails_helper"

RSpec.feature 'User sends an email' do
  background do
    clear_emails
  end

  scenario 'User creates a new email with valid inputs for all fields' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'
    fill_in 'email_email', :with => 'jon@test.com'
    fill_in 'email_phone_number', :with => '1231231234'
    find('#email_message_trix_input_email', visible: false).set('Testing')

    click_button "Submit"
    sleep(0.1)

    open_email('jon@test.com')
    expect(current_email).to have_content('Thank you for contacting')

    open_email('support@frankenkopter.com')
    expect(current_email).to have_content('Testing')

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
    expect(page).to have_text("The following 4 errors prevented your email from being sent:")

  end

  scenario 'User creates a new email with one invalid input' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'
    fill_in 'email_email', :with => 'jon@test.com'
    fill_in 'email_phone_number', :with => '1231231234'

    click_button "Submit"

    expect(page).to have_text("The following 1 error prevented your email from being sent:")
  end

  scenario 'user creates a new email with valid full_name' do
    visit contact_path

    fill_in 'email_full_name', :with => 'Jon'

    click_button 'Submit'
    expect(page).to have_text('The following 3 errors prevented your email ')
  end
end
