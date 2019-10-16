class ApplicationController < ActionController::Base
  def require_admin!
    unless current_user.admin?
      flash[:error] = 'You are not authorized to do that'
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admins_path
    else
      super
    end
  end
end
