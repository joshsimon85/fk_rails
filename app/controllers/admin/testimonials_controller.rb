class Admin::TestimonialsController < Admin::BaseController
  before_action :set_filter!, only: :index
  before_action :set_records_count!, only: :index
  before_action :set_pagination_values!, only: :index

  def index
    @testimonials = Testimonial.limit_and_sort(10 * (@current_page - 1), { :created_at => @order }, build_filter)
  end

  def edit
    @testimonial = Testimonial.find(params[:id])
  end

  def update
    @testimonial = Testimonial.find(params[:id])
    @testimonial.update(
      :message => params[:testimonial][:message],
      :published => params[:testimonial][:published]
    )
    if @testimonial.valid?
      flash[:success] = 'The testimonial has been updated'
      redirect_to admin_testimonials_path
    else
      flash.now[:error] = 'The testimonial could not be updated'
      render :edit
    end
  end

  def destroy
    Testimonial.find(params[:id]).delete
    flash[:success] = 'The selected testimoial has been deleted'
    redirect_to admin_testimonials_path
  end

  def destroy_multiple
    testimonial_ids = params[:testimonials].keys.map(&:to_i)
    Testimonial.where(id: testimonial_ids).delete_all
    flash[:success] = 'The selected testimonials have been deleted'
    redirect_to admin_testimonials_path
  end

  private

  def set_records_count!
    if @filter
      @records_count = Testimonial.where(:published => @filter).count
    else
      @records_count = Testimonial.count
    end
  end

  def set_filter!
    if %w(true false).include?(params[:published])
      @filter = params[:published]
    else
      @filter = nil
    end
  end

  def build_filter
    query = nil
    if %w(true false).include?(@filter)
      query = { :published => @filter }
    end
    query
  end
end
