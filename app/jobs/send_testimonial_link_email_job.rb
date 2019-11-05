class SendTestimonialLinkEmailJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
     Report.create(
       error_type: 'Record Not Found',
       process: 'Send Testimonial Link Email',
       message: exception
     )
  end

  def perform(user_id)
    UserMailer.testimonial_link_email(user_id).deliver_now
  end
end
