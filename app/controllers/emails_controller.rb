class EmailsController < ApplicationController
  def new
    @email = Email.new
  end

  def create
    @email = Email.create(email_params)
    if @email.valid?
      EmailWorker.perform_later('user', @email.id)
      EmailWorker.perform_later('admin', @email.id)
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
