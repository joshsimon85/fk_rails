module ApplicationHelper
  def flash_class(key)
    "alert alert-dismissible fade show alert-#{key}"
  end

  def format_datetime(datetime)
    datetime.strftime('%a %m/%d/%Y %l:%M %P')
  end

  def format_name(full_name)
    name_list = full_name.titleize.split(' ')
    "#{name_list[0]} #{name_list[-1].slice(0)}."
  end
end
