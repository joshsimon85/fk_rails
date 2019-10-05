class UserMailer < ApplicationMailer
  default from: 'support@frankenkopter.com'

  def contact_page_email
    @params = params[:email]
    @url = 'http://www.frankenkopter.com/contact'
    mail(to: @params.email, subject: 'Thank you for contacting us!')
  end
end
