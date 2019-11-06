class Admin::AdminsController < Admin::BaseController
  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    @user.update(user_params)
    if @user.valid?
      flash[:success] = 'Your account has been updated'
      redirect_to admin_root_path
    else
      flash.now[:error] = 'Your profile was not able to be updated'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :phone_number, :email)
  end
end
