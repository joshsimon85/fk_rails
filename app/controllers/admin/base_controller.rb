class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  private

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
end
