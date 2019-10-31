class SendThankYouEmailWorker < ApplicationJob
  queue_as :default

  def perform(type, email_id)
    if type == 'admin'
      send_admin_email(email_id)
    else
      send_user_email(email_id)
    end
  end

  private

  def send_user_email(email_id)
    UserMailer.testimonial_page_email(email_id).deliver_now
  end

  def send_admin_email(email_id)
    AdminMailer.testimonial_page_email(email_id).deliver_now
  end
end
