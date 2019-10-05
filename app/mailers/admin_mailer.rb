class AdminMailer < ApplicationMailer
  def contact_page_email
    @params = params[:email]
    @url = 'http://www.frankenkopter.com/contact'
    mail(to: 'kasey@frankenkopter.com', from: @params.email, subject: "New email from #{@params.full_name} <www.frankenkopter.com/contact>")
  end
end
