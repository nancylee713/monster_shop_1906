class Merchant::CouponsController < Merchant::BaseController
  before_action :set_merchant
  before_action :set_coupon, only: [:edit, :update, :destroy]

  def set_merchant
    @merchant = current_user.merchant
  end

  def set_coupon
    @coupon = @merchant.coupons.find(params[:id])
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

  def edit
  end

  def update
    @coupon.update(coupon_params)
    if @coupon.save
      flash[:new_coupon] = "Your coupon is updated!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @coupon.destroy
    flash[:delete_coupon] = "Your coupon is now deleted!"
    redirect_to merchant_coupons_path
  end

  private

  def coupon_params
    if params[:coupon]
      params.require(:coupon).permit(:name, :value, :is_percent, :item_id)
    else
      params.permit(:name, :value, :is_percent, :item_id)
    end
  end
end
