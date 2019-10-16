module ApplicationHelper
  def flash_class(key)
    "alert alert-dismissible fade show alert-#{key}"
  end

  def format_datetime(datetime)
    datetime.strftime('%a %m/%d/%Y %l:%M %P')
  end
end
