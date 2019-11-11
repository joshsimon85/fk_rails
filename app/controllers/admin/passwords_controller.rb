class Admin::PasswordsController < Admin::BaseController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if User.authenticate(params[:user][:email], params[:user][:current_password])
      if @user.update(user_params)
        flash[:success] = 'Your password has been updated'
        bypass_sign_in @user
        redirect_to admin_root_path
      else
        flash.now[:error] = 'Unable to update your password'
        render :edit
      end
    else
      flash.now[:error] = 'Unable to update your password'
      @user.errors.add(:current_password, 'does not match')
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
