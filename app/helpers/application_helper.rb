module ApplicationHelper
  def flash_class(key)
    "alert alert-dismissible fade show alert-#{key}"
  end
end
