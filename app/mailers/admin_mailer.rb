class AdminMailer < ApplicationMailer
  def contact_page_email(email_id)
    @email = Email.find(email_id)
    @url = 'https://www.frankenkopter.com/contact'
    mail(to: 'kasey@frankenkopter.com', from: @email.email, subject: "New email from #{@email.full_name} <www.frankenkopter.com/contact>")
  end

  def new_testimonial_email(user_id)
    @user = User.find(user_id)
    @url = 'https://www.frankenkopter.com/testimonail'
    mail(to: 'kasey@frankenkopter.com', from: @user.email, subject: "New testimonial from #{@user.full_name}")
  end
end
