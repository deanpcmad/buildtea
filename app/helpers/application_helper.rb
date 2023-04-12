module ApplicationHelper

  def bootstrap_class_for(flash_type)
    {
      alert: "alert-danger",
      notice: "alert-success"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

end
