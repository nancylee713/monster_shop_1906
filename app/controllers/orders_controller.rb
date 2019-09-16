class OrdersController <ApplicationController

  def new
    @order = current_user.orders.new
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

  private
  def order_params
    params.require(:order).permit(:name, :address_id, :user_id)
  end
end
