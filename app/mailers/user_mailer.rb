class UserMailer < ApplicationMailer
  default from: 'kasey@frankenkopter.com'

  def contact_page_email(email_id)
    @email = Email.find(email_id)
    @url = 'https://www.frankenkopter.com/contact'
    mail(to: @email.email, subject: 'Thank you for contacting us!')
  end

  def testimonial_link_email(user_id)
    @user = User.find(user_id)
    @url = 'https://www.frankenkopter.com/testimonial'
    mail(to: @user.email, subject: 'Your feedback is very important to us!')
  end
end
