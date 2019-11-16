class ApplicationController < ActionController::Base
  before_action :set_raven_context

  def require_admin!
    unless current_user && current_user.admin?
      flash[:error] = 'You are not authorized to do that'
      redirect_to root_path
    end
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    else
      root_path
    end
  end

  def set_current_page!
    total_pages = (@records_count / 10.0).ceil
    page = params[:page].to_i
    if page == 0
      @current_page = 1
    elsif total_pages < page
      @current_page = total_pages
    else
      @current_page = page
    end
  end

  def set_order!
    if %w(desc asc).include?(params[:order])
      @order = params[:order]
    else
      @order = 'desc'
    end
  end

  def set_pagination_values!
    set_current_page!
    set_order!
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params:to_unsafe_h, url: request.url)
  end
end
