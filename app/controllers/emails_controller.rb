class EmailsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :delete, :destroy]
  before_action :require_admin!, only: [:index, :show, :delete, :destroy, :multiple_delete]

  def index
    current_page = params[:page] || 1
    @current_page = current_page.to_i
    @emails = Email.limit(10)
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
  end

  def destroy
    page = params[:page] || 1
    current_page = page.to_i
    user = User.find(params[:admin_id])
    Email.destroy(params[:id])
    flash[:success] = 'The email record has been removed'
    redirect_to admin_emails_path(user, :page => current_page)
  end

  def destroy_multiple
    user = User.find(params[:admin_id])
    page = params[:page] || 1
    current_page = page.to_i
    email_ids = params[:emails].keys.map(&:to_i)
    email_ids.each do |id|
      Email.find(id).destroy
    end
    flash[:success] = 'The email records have been removed'
    redirect_to admin_emails_path(user, :page => current_page)
  end

  private

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
