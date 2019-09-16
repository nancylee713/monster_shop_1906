class OrdersController <ApplicationController

  def new
    if current_user.addresses.present?
      @order = current_user.orders.new
    else
      flash[:no_address] = "There is currently no shipping address available. Please add a new address to proceed to checkout"
      redirect_to profile_addresses_new_path
    end
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel_order
    order.update(status: 3)
    order.save

    flash[:success] = "Your order has been cancelled"
    redirect_to "/profile"
  end

  def create
    @order = current_user.orders.create(order_params)
    if @order.save
      cart.save_to_db(current_user, @order)
      session.delete(:cart)
      flash[:order] = "Your order has been created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def edit
    @order = current_user.orders.find(params[:id])
    @address = @order.address
  end

  def update
    @order = current_user.orders.find(params[:id])
    @address = @order.address
    @address.update(address_params)
    if @address.save
      flash[:order_update] = "Your shipping address has been updated!"
      redirect_to "/profile/orders/#{@order.id}"
    else
      flash[:miss_update] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
  def order_params
    params.require(:order).permit(:name, :address_id, :user_id)
  end

  def address_params
    params.require(:address).permit(:street, :city, :state, :zipcode)
  end
end
