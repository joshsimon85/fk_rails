class SendTestimonialLinkEmailWorker < ApplicationJob
  queue_as :default

  def perform(user_id)
    UserMailer.testimonial_link_email(user_id).deliver_now
  end
end
