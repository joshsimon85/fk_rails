class EmailWorker < ApplicationJob
    queue_as :default

    def perform(type, email_id)
      if type == 'admin'
        send_admin_email(email_id)
      else
        send_user_email(email_id)
      end 
    end
  end

  private

  def send_user_email
    UserMailer.contact_page_email(email_id).deliver_now

  def send_admin_email(email_id)
    AdminMailer.contact_page_email(email_id).deliver_now
  end
end
