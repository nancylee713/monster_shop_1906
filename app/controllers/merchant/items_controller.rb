class Merchant::ItemsController < Merchant::BaseController
  before_action :set_merchant

  def set_merchant
    @merchant = current_user.merchant
  end

  def index
    @items = @merchant.items
  end

  def new
    @item = @merchant.items.new
  end

  def create
    @item = @merchant.items.create(item_params)

    if @item.save
      flash[:new_item] = "Your new item is saved!"
      redirect_to merchant_user_index_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      flash[:success] = "Your item is now updated!"
      redirect_to merchant_user_index_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def update_status
    # @item = Item.find(params[:item_id])
    @item = @merchant.items.find(params[:item_id])
    @item.toggle_status
    if @item.active?
      flash[:success] = "This item is now available for sale"
    else
      flash[:success] = "This item is no longer for sale"
    end
    redirect_to merchant_user_index_path
  end

  def destroy
    item = Item.find(params[:id])
    @merchant.items.delete(item)
    item.destroy
    flash[:delete_item_warning] = "#{item.name} is now deleted!"
    redirect_to merchant_user_index_path
  end

  private

  def item_params
    if params[:item]
      params.require(:item).permit(:name,:description,:price,:inventory,:image)
    else
      params.permit(:name,:description,:price,:inventory,:image)
    end
  end
end
