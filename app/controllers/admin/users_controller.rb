class Admin::UsersController < Admin::BaseController
  before_action :set_records_count!
  before_action :set_pagination_values!

  def index
    @customers = User.limit_and_sort(10 * (@current_page - 1), { :created_at => @order }, { admin: false })
  end

  private

  def set_records_count!
    @records_count = User.where.not(admin: true).count
  end
end
