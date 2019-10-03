class UserMailer < ApplicationMailer::Base
  def confirmation_email
    @params = params[:email]
    @url = 'http://www.frankenkopter.com/contact'
    mail(to:@params.email, subject: 'Thank you for contacting us!')
  end
end
