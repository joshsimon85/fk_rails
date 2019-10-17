class AdminsController < UsersController
  before_action :require_admin!

  def index
    @records_count = Email.count
  end
end
