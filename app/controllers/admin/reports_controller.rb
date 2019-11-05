class Admin::ReportsController < Admin::BaseController
  before_action :set_records_count!
  before_action :set_pagination_values!

  def index
    @reports = Report.limit_and_sort(10 * (@current_page - 1), { :created_at => @order })
  end

  def destroy
    Report.delete(params[:id])
    flash[:success] = 'The report has been deleted'
    redirect_to admin_reports_path(:page => @current_page, :order => @order)
  end

  def destroy_multiple
    report_ids = params[:reports].keys.map(&:to_i)
    Report.where(id: report_ids).delete_all
    flash[:success] = 'The selected reports have been removed'
    redirect_to admin_reports_path(:page => @current_page, :order => @order)
  end

  private

  def set_records_count!
    @records_count = Report.count
  end
end
