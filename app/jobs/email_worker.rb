class EmailWorker < ApplicationJob
  queue_as :default

  def perform(email_id)
    send_user_email(email_id)
    send_admin_email(email_id)
  end

  private

  def send_user_email(email_id)
    UserMailer.contact_page_email(email_id).deliver
  end

  def send_admin_email(email_id)
    AdminMailer.contact_page_email(email_id).deliver
  end
end
