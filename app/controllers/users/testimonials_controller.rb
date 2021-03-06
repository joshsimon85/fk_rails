class Users::TestimonialsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_records_count!, only: :index
  before_action :set_pagination_values!, only: :index

  def index
    @testimonials = Testimonial.limit_and_sort(10 * (@current_page - 1), { :created_at => 'desc' })
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
      @testimonial = Testimonial.new(testimonial_params.merge(
        {
          creator: params[:creator],
          creator_email: params[:creator_email],
          creator_avatar_url: params[:creator_avatar_url]
        }
      ))

      if verify_recaptcha && @user && @testimonial.save
        @user.update(:testimonial_token => User.generate_token)
        SendThankYouEmailJob.perform_later('user', @user.id)
        SendThankYouEmailJob.perform_later('admin', @user.id)
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

  def edit
    @user = current_user
    @testimonial = Testimonial.find_by(:creator_email => @user.email)
  end

  def update
    @testimonial = Testimonial.find_by(:creator_email => current_user.email)
    @testimonial.update(:message => params[:testimonial][:message])
    if @testimonial.valid?
      flash[:success] = 'Your testimonail has been updated'
      redirect_to edit_user_registration_path
    else
      flash.now[:error] = 'Your testimonial could not be updated'
      render :edit
    end
  end

  def destroy
    Testimonial.find_by(:creator_email => current_user.email).delete
    flash[:success] = 'Your testimonial has been deleted'
    redirect_to edit_user_registration_path
  end

  def expired_token; end

  private

  def testimonial_params
    params.require(:testimonial).permit(:message)
  end

  def set_records_count!
    @records_count = Testimonial.where(:published => true).count
  end
end
