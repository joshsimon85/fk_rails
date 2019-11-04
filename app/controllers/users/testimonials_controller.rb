class Users::TestimonialsController < ApplicationController
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

  def expired_token; end

  private

  def testimonial_params
    params.require(:testimonial).permit(:message)
  end

  def format_name(creator)
    name_list = creator.titleize.split(' ')
    "#{name_list[0]} #{name_list[-1].slice(0)}."
  end
end
