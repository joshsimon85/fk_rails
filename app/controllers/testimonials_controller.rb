class TestimonialsController < ApplicationController
  def new
    @user = User.find_by(testimonial_token: params[:token])

    if @user
      @testimonial = Testimonial.new
    else
       # redirect_to expired token path
    end
    #@testimonial = Testimonial.find_by(token: params[:token])
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

  private

  def testimonial_params
    params.require(:testimonial).permit(:message)
  end
end
