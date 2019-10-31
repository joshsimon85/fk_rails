class Admin::EmailsController < Admin::BaseController
  before_action :set_records_count!, except: :show
  before_action :set_pagination_values!, except: :show

  def index
    @emails = Email.limit_and_sort(10 * (@current_page - 1), @order)
  end

  def show
    @email = Email.find(params[:id])
  end

  def destroy
    Email.destroy(params[:id])
    flash[:success] = 'The email has been removed'
    redirect_to admin_emails_path(:page => @current_page, :order => @order)
  end

  def destroy_multiple
    email_ids = params[:emails].keys.map(&:to_i)
    Email.where(id: email_ids).delete_all
    flash[:success] = 'The selected emails have been removed'
    redirect_to admin_emails_path(:page => @current_page, :order => @order)
  end

  private

  def set_records_count!
    @records_count = Email.count
  end
end
