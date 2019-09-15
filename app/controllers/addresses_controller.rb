class AddressesController<ApplicationController
  before_action :set_user

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

  private

  def address_params
   params.require(:address).permit(:street, :city, :state, :zipcode, :nickname)
 end
end
