class AdminMailer < ApplicationMailer
  def contact_page_email(email_id)
    @email = Email.find(email_id)
    @url = 'http://www.frankenkopter.com/contact'
    mail(to: 'support@frankenkopter.com', from: @email.email, subject: "New email from #{@email.full_name} <www.frankenkopter.com/contact>")
  end
end
