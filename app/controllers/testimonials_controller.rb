class TestimonialsController < ApplicationController
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
    @user = User.find_by(email: params[:email])
    @testimonial = Testimonial.create(testimonial_params.merge({user_id: @user.id}))
    if @testimonial.valid?
      flash[:success] = 'Your testimonial has been added!'
      redirect_to root_path
    else
      flash[:error] = 'Your testimonial could not be submitted!'
      render 'new'
    end
  end

  def expired_token; end

  private

  def testimonial_params
    params.require(:testimonial).permit(:message)
  end
end
