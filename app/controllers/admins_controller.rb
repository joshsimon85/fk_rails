class AdminsController < UsersController
  before_action :require_admin!

  def index
    @email_count = Email.count
  end
end
