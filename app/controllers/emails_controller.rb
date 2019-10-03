class EmailsController < ApplicationController
  def index

  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.create(email_params)
    if @email.valid?
      binding.pry
      #create a new email using these params
      #params['email']['message']
      flash[:success] = 'Your email has been sent'
      redirect_to root_path
    else
      flash.now[:error] = 'There was a problem sending your email'
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
