class Merchant::CouponsController < Merchant::BaseController
  before_action :set_merchant

  def set_merchant
    @merchant = current_user.merchant
  end

  def index
    @coupons = @merchant.coupons
  end

  def new
    @coupon = @merchant.coupons.new
  end

  def create
    @coupon = @merchant.coupons.create(coupon_params)
    if @coupon.save
      flash[:new_coupon] = "New coupon is created!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :value, :is_percent, :item_id)
  end
end
