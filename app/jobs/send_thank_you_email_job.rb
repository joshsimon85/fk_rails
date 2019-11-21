class SendThankYouEmailJob < ApplicationJob
  queue_as :mailers

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
     Report.create(
       error_type: 'Record Not Found',
       origin: 'Send Thank You Email',
       message: exception
     )
  end

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
