class AddressesController<ApplicationController
  before_action :set_user
  before_action :set_address, only: [:edit, :update, :destroy]

  def set_address
    @address = @user.addresses.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def new
    @address = @user.addresses.new
  end

  def create
    @address = @user.addresses.create(address_params)
    if @address.save
      flash[:success] = "New address has been added to your account!"
      redirect_to profile_path
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      redirect_to profile_addresses_new_path
    end
  end

  def edit
  end

  def update
    @address.update(address_params)
    if @address.save
      flash[:success] = "Your address is now updated!"
      redirect_to profile_path
    else
      flash[:error] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @address.can_be_deleted?
      @user.addresses.delete(@address)
      @address.destroy
      flash[:delete_item_warning] = "Your #{@address.nickname} address is now deleted!"
    else
      flash[:warning] = "This address has been already used in a shipped order and cannot be deleted at this time."
    end
      redirect_to profile_path
  end

  private

  def address_params
   params.require(:address).permit(:street, :city, :state, :zipcode, :nickname)
 end
end
