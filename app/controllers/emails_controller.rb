class EmailsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :delete, :destroy]
  before_action :require_admin!, only: [:index, :show, :delete, :destroy, :multiple_delete]
  before_action :set_records_count!, except: [:new, :create]
  before_action :set_current_page!, except: [:new, :create, :show]
  before_action :set_order!, except: [:new, :create, :show]

  def index
    @emails = Email.limit_and_sort_emails(10 * (@current_page - 1), @order)
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
    Email.destroy(params[:id])
    flash[:success] = 'The email record has been removed'
    redirect_to admin_emails_path(current_user, :page => @current_page, :order => @order)
  end

  def destroy_multiple
    email_ids = params[:emails].keys.map(&:to_i)
    Email.where(id: email_ids).delete_all
    flash[:success] = 'The email records have been removed'
    redirect_to admin_emails_path(current_user, :page => @current_page, :order => @order)
  end

  private

  def set_records_count!
    @records_count = Email.count
  end

  def set_current_page!
    total_pages = (@records_count / 10.0).ceil
    page = params[:page].to_i
    if page == 0
      @current_page = 1
    elsif total_pages < page
      @current_page = total_pages
    else
      @current_page = page
    end
  end

  def set_order!
    if %w(desc asc).include?(params[:order])
      @order = params[:order]
    else
      @order = 'desc'
    end
  end

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
