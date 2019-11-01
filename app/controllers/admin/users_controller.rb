class Admin::UsersController < Admin::BaseController
  before_action :set_records_count!, only: :index
  before_action :set_pagination_values!, only: :index

  def index
    @customers = User.limit_and_sort(10 * (@current_page - 1), { :full_name => @order }, { admin: false })
  end

  def send_testimonial_link
    @user = User.find(params[:id])
    if @user
      SendTestimonialLinkEmailWorker.perform_later(@user.id)
      flash[:success] = 'A link for the testimonial has been sent'
      redirect_to admin_customers_path
    else

    end
  end

  private

  def set_records_count!
    @records_count = User.where.not(admin: true).count
  end
end
