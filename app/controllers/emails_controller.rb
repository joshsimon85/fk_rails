class EmailsController < AdminsController
  def index
    @emails = Email.limit_and_sort(10 * (@current_page - 1), @order)
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

  def email_params
    params.require(:email).permit(:full_name, :email, :phone_number, :message)
  end
end
