class AdminsController < UsersController
  before_action :authenticate_user!, only: [:index, :show, :delete, :destroy]
  before_action :require_admin!, only: [:index, :show, :delete, :destroy, :multiple_delete]
  before_action :set_records_count!, except: [:new, :create]
  before_action :set_current_page!, except: [:new, :create, :show]
  before_action :set_order!, except: [:new, :create, :show]

  private

  def set_records_count!
    if self.controller_path == 'testimonials'
      @records_count = Testimonial.count
    else
      @records_count = Email.count
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
end
