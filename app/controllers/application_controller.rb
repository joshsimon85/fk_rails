class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    binding.pry
    if resource.admin?
      admins_path
    else
      super
    end
  end
end
