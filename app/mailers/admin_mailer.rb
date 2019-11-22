class AdminMailer < ApplicationMailer
  def contact_page_email(email_id)
    @email = Email.find(email_id)
    @url = 'https://www.frankenkopter.com/contact'
    mail(to: 'kasey@frankenkopter.com', from: 'mail.frankenkopter.com', reply_to: @email.email, subject: "New email from #{@email.full_name} || FrankenKopter Contact Form")
  end

  def new_testimonial_email(user_id)
    @user = User.find(user_id)
    @url = 'https://www.frankenkopter.com/testimonial'
    mail(to: 'kasey@frankenkopter.com', from: 'mail.frankenkopter.com', reply_to: @user.email, subject: "New testimonial from #{@user.full_name} || FrankenKopter Testimonial")
  end
end
