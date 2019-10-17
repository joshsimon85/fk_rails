class EmailsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :delete, :destroy]
  before_action :require_admin!, only: [:index, :show, :delete, :destroy, :multiple_delete]

  def index
    page = params[:page] || 1
    @current_page = page.to_i
    @emails = Email.limit(10).offset(10 * (@current_page - 1))
    @email_count = Email.count
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.create(email_params)
    if @email.valid?
      EmailWorker.perform_later('user', @email.id)
      EmailWorker.perform_later('admin', @email.id)
      flash[:success] = 'Your email has been sent'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @email = Email.find(params[:id])
    @email_count = Email.count
  end

  def destroy
    current_page = params[:page].to_i
    user = User.find(params[:admin_id])
    Email.destroy(params[:id])
    flash[:success] = 'The email record has been removed'
    redirect_to after_email_delete_path(user, current_page)
  end

  def destroy_multiple
    user = User.find(params[:admin_id])
    current_page = params[:page].to_i
    email_ids = params[:emails].keys.map(&:to_i)
    Email.where(id: email_ids).delete_all
    flash[:success] = 'The email records have been removed'
    redirect_to after_email_delete_path(user, current_page)
  end

  private

  def after_email_delete_path(user, current_page)
    record_count = Email.count
    if current_page == 0
      admin_emails_path(user)
    elsif current_page <= (record_count / 10.0).ceil
      admin_emails_path(user, :page => current_page)
    else
      admin_emails_path(user, :page => (record_count / 10.0).ceil)
    end
  end

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
