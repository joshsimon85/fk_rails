class SendThankYouEmailJob < ApplicationJob
  queue_as :default

  def perform(type, user_id)
    if type == 'admin'
      send_admin_email(user_id)
    else
      send_user_email(user_id)
    end
  end

  private

  def send_user_email(user_id)
    UserMailer.thank_you_email(user_id).deliver_now
  end

  def send_admin_email(user_id)
    AdminMailer.new_testimonial_email(user_id).deliver_now
  end
end
