module ApplicationHelper
  def flash_class(key)
    "alert alert-dismissible fade show alert-#{key}"
  end

  def format_datetime(datetime)
    datetime.strftime('%a %m/%d/%Y %l:%M %P')
  end

  def build_query_params(options={})
    query = { :page => options[:page], :order => options[:order] }
    if options.keys.include?(:published)
      query.merge!(:published => options[:published])
    end
    query
  end
end
