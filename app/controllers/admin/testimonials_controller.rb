class Admin::TestimonialsController < Admin::BaseController
  before_action :set_filter!, only: :index
  before_action :set_records_count!, only: :index
  before_action :set_pagination_values!, only: :index

  def new
    @testimonial = Testimonial.new
  end

  def create
    @testimonial = create_testimonial
    if @testimonial.valid?
      if params[:testimonial][:highlight].present?
        @highlight = create_highlight
        if @highlight.valid?
          flash[:success] = 'Your testimonial has been created!'
          redirect_to admin_testimonials_path
        else
          flash[:error] = 'A problem was encountered while submitting your hightlight'
          redirect_to new_admin_testimonial_highlight_path(@testimonial)
        end
      else
        flash[:success] = 'Your testimonial has been saved!'
        redirect_to admin_testimonials_path
      end
    else
      flash.now[:error] = 'Your testimonial could not be submitted'
      render :new
    end
  end

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

  def create_testimonial
    Testimonial.create(
      :creator => params[:testimonial][:creator],
      :creator_email => params[:testimonial][:creator_email],
      :creator_avatar_url => create_avatar_url(params[:testimonial][:creator_email]),
      :message => params[:testimonial][:message],
      :published => params[:testimonial][:published]
    )
  end

  def create_highlight
    Highlight.create(
      :testimonial_id => @testimonial.id,
      :highlight => params[:testimonial][:highlight]
    )
  end

  def create_avatar_url(email)
    return unless email
    email_address = email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "#{hash}?d=mm"
  end

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
