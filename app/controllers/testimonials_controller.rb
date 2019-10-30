class TestimonialsController < AdminsController
  before_action :set_filter!, only: [:index]
  before_action :authenticate_user!, only: [:index, :edit, :delete, :destroy]
  before_action :require_admin!, only: [:index, :edit, :delete, :destroy, :multiple_delete]

  def index
    reset_records_count!
    @testimonials = Testimonial.limit_and_sort(10 * (@current_page - 1), @order, build_filter)
  end

  def new
    @user = User.find_by(testimonial_token: params[:token])
    if @user
      @testimonial = Testimonial.new
    else
      flash[:error] = 'An error was encountered while processing your request!'
       redirect_to expired_token_path
    end
  end

  def create
    @user = User.find_by(testimonial_token: params[:token])
    if @user
      @testimonial = Testimonial.create(testimonial_params.merge({user_id: @user.id, created_by: format_name(@user.full_name)}))
      if @testimonial.valid? && @user
        @user.update(:testimonial_token => User.generate_token)
        flash[:success] = 'Your testimonial has been added!'
        redirect_to root_path
      else
        flash[:error] = 'Your testimonial could not be submitted!'
        render 'new'
      end
    else
      flash[:error] = 'An error was encountered while processing your request!'
      redirect_to expired_token_path
    end
  end

  # def show
  #   @testimonial = Testimonial.find(params[:id])
  # end

  def edit
    @testimonial = Testimonial.find(params[:id])
  end

  def update
    @testimonial = Testimonial.find(params[:id])
    @testimonial.update(
      :created_by => params[:testimonial][:created_by],
      :message => params[:testimonial][:message],
      :published => params[:testimonial][:published]
    )
    if @testimonial.valid?
      flash[:success] = 'The testimonial has been updated'
      redirect_to admin_testimonials_path(current_user)
    else
      flash.now[:error] = 'The testimonial could not be updated'
      render :edit
    end
  end

  def expired_token; end

  private

  def testimonial_params
    params.require(:testimonial).permit(:message)
  end

  def set_filter!
    if %w(true false).include?(params[:published])
      @filter = params[:published]
    else
      @filter = nil
    end
  end

  def reset_records_count!
    if @filter
      @records_count = Testimonial.where(:published => @filter).count
    else
      @records_count = Testimonial.count
    end
  end

  def build_filter
    query = nil
    if %w(true false).include?(@filter)
      query = { :published => @filter }
    end
    query
  end

  def format_name(creator)
    name_list = creator.titleize.split(' ')
    "#{name_list[0]} #{name_list[-1].slice(0)}."
  end
end
