class AdminsController < ApplicationController
  def index
    @user = current_user
    @email_count = Email.count
  end
end
