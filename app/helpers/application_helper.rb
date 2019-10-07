module ApplicationHelper
  def flash_class(key)
    if key == 'error'
      'alert alert-dismissible fade show alert-danger'
    else
      'alert alert-dismissible fade show alert-success'
    end
  end
end
