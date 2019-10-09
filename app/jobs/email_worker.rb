class EmailWorker < ApplicationJob
  queue_as :default
  sidekiq_options backtrace: true

  def perform(email_id)
    send_user_email(email_id)
    send_admin_email(email_id)
  end

  def send_user_email(email_id)
    UserMailer.contact_page_email(email_id).deliver
  end

  def send_admin_email(email_id)
    AdminMailer.contact_page_email(email_id).deliver
  end
end
