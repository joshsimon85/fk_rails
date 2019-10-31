require "rails_helper"

RSpec.feature 'Admin interacts with email' do
  before do
    12.times do
      Fabricate(:email)
    end
  end

  let(:admin) { Fabricate(:user, admin: true, password: 'password') }

  scenario 'User creates a new email with valid inputs for all fields' do
    visit_log_in_page

    admin_logs_in

    click_on_stored_emails
    # check pagination 10 per page limit
    expect(page).to have_selector('a', :text => '2')

    click_page_2

    # ensure page 2 after deleting when there are still 11 records left
    delete_first_email_on_page
    expect(active_page).to have_content('2')

    # ensure page 1 when on page 2 and a delete occurs leaving only 10 records
    delete_first_email_on_page
    expect(page).to have_selector('a', :text => '1')
    expect(page).not_to have_selector('a', :text => '2')

    click_delete_checkbox(1)
    click_delete_checkbox(2)
    click_delete_checkbox(3)

    click_bulk_delete_selected_emails
    expect(page).to have_content('The email records have been removed')

    log_out

    visit_contact_page
    create_and_submit_contact_form

    visit_log_in_page

    admin_logs_in

    click_on_stored_emails

    expect(email_list.first).to have_content('Jon Doe')

    sort_emails_by_ascending_order

    expect(page).not_to have_content('Sort By Ascending')
    expect(email_list.last).to have_content('Jon Doe')
  end

  private

  def active_page
    within(:css, 'ul.pagination') do
      find('.active')
    end
  end

  def click_page_2
    click_link('2')
  end

  def visit_contact_page
    visit contact_path
  end

  def sort_emails_by_ascending_order
    click_link 'Sort By Ascending'
  end

  def click_on_stored_emails
    click_link 'Stored Emails'
  end

  def visit_log_in_page
    visit new_user_session_path
  end

  def click_delete_checkbox(n)
    checkboxes = find_all_delete_checkboxes
    checkboxes[n - 1].click
  end

  def click_bulk_delete_selected_emails
    click_button 'Delete Selected'
  end

  def create_and_submit_contact_form
    find('#email_full_name').set('Jon Doe')
    find('#email_email').set('jon@test.com')
    find('#email_phone_number').set('1231231234')
    find('#email_message_trix_input_email', visible: false).set('Testing')

    click_button "Submit"
    sleep(0.1)
  end

  def admin_logs_in
    fill_in 'Email Address', :with => admin.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end

  def delete_first_email_on_page
    first(:link, 'Delete').click
  end

  def find_all_delete_checkboxes
    within(:css, 'section.bg-light') do
      find_all("[type='checkbox']")
    end
  end

  def click_checkbox(checkbox)
    checkbox.click
  end

  def log_out
    first(:link, :text => 'Sign Out').click
  end

  def email_list
    within(:css, 'section.bg-light') do
      find_all('dl')
    end
  end
end
