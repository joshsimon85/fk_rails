class ApplicationController < ActionController::Base
  def require_admin
    unless current_user && is_admin?
      flash[:error] = 'You must be logged in to do that'
      redirect_to root_path
    end
  end

  def is_admin?
    current_user.admin?
  end
end
