module ApplicationHelper
  def bootstrap_class_for flash_type
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "limit"
        "alert-danger"
      when "incomplete_order"
        "alert-danger"
      when "incomplete_merchant"
        "alert-danger"
      when "notice"
        "alert-info"
      when "delete_item_warning"
        "alert-danger"
      when "miss_update"
        "alert-danger"
      when "no_address"
        "alert-danger"
      when "delete_warning"
        "alert-danger"
      when "inactive_item"
        "alert-danger"
    end
  end
end
