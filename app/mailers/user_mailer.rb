class UserMailer < ApplicationMailer
  default from: 'support@frankenkopter.com'

  def contact_page_email(email_id)
    @email = Email.find(email_id)
    @url = 'http://www.frankenkopter.com/contact'
    mail(to: @email.email, subject: 'Thank you for contacting us!')
  end
end
