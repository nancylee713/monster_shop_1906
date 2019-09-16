class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart, :current_user, :current_merchant_employee?, :current_merchant_admin?, :current_admin?, :profile_img

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant_employee?
    current_user && current_user.merchant_employee?
  end

  def current_merchant_admin?
    current_user && current_user.merchant_admin?
  end

  def current_admin?
    current_user && current_user.admin_user?
  end

  def visitor_with_items?
    current_user.nil? && cart.contents.present?
  end

  def require_user
    render file: "/public/404" if current_user.nil?
  end

  def profile_img
    [
      "https://image.flaticon.com/icons/svg/145/145842.svg",
      "https://image.flaticon.com/icons/svg/145/145848.svg",
      "https://image.flaticon.com/icons/svg/145/145847.svg",
      "https://image.flaticon.com/icons/svg/145/145843.svg",
      "https://image.flaticon.com/icons/svg/145/145849.svg",
      "https://image.flaticon.com/icons/svg/145/145846.svg"
    ].sample
  end
end
