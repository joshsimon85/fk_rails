class EmailsController < ApplicationController
  before_action :require_admin, except: [:new, :create]

  def new
    @email = Email.new
  end

  def create
    @email = Email.create(email_params)
    if @email.valid?
      UserMailer.with(email: @email).contact_page_email.deliver_later
      AdminMailer.with(email: @email).contact_page_email.deliver_later
      flash[:success] = 'Your email has been sent'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @email = Email.find(params[:id])
  end

  private

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
