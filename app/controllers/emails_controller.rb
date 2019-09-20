class EmailsController < ApplicationController
  def create
    @email = Email.create(email_params)
    binding.pry
    if @email.valid?

    else

    end
  end

  private

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
