class Merchant::CouponsController < Merchant::BaseController
  before_action :set_merchant

  def set_merchant
    @merchant = current_user.merchant
  end

  def index
    @coupons = @merchant.coupons
  end
end
