class FamilyController < ActionController::Base
  layout 'application'
  before_action :set_family, only: [:show,:edit,:destroy,:update,:add_family,:remove_family]
  before_action :is_admin, only: [:edit,:destroy,:update,:create,:new,:family_admin,:family_deliver,:delivery_is_sent,:revoke_delivery]
  before_action :mine_or_admin, only: [:my_family]
  before_action :address_exist, only: [:delivery_is_sent,:revoke_delivery]
  def index
      @families = Family.all.available
  end
  def show
      if !@family.notTaken && !params[:mine]
        redirect_to root_path
      end
      if params[:mine] == "true"
        @items = @family.items.isMine current_user.id
      else
        @items = @family.items.all.available
      end
  end
  def edit
    @url = edit_family_path(@family)
  end
  def new
    @family = Family.new
    @url = new_family_path(@family)
  end
  def update
    if @family.update_attributes(family_params)
      redirect_to @family
    else
      redirect_to edit_family_path(@family), alert: @family.errors.values.first.to_s
    end
  end
  def create
    @family = Family.new(family_params)
    if @family.save
      @family.update_attribute("cost",0)
      #@family.update_attribute("lf",0)
      redirect_to "/family_admin/" + @family.id.to_s
    else
      redirect_to new_family_path(@family), alert: @family.errors.values.first.to_s
    end
  end
  def destroy
    @family.destroy!
    if params[:mode] != nil
      redirect_to admin_path(mode: "family")
    else
      redirect_to root_path
    end
  end
  def add_family
      current_user.familys << @family
      redirect_to user_path
  end
  def remove_family
      @family.items.each do |i|
        i.update_attribute("donation",false)
        current_user.items.delete(i)
      end
      current_user.familys.delete(@family)
      redirect_to user_path
  end
  def set_family
      @family = Family.find(params[:id])
  end
  def family_params
    params.require(:family).permit(:name,:phone,:email,:city,:address)
  end
  def mine_or_admin
    if current_user == nil
      redirect_to root_path
    elsif !current_user.email_verify
      redirect_to "/verify/#{current_user.id}?resend=t"
    elsif !(Family.find(params[:id]).mine current_user.id)
      if !current_user.admin
        redirect_to root_path
      end
    end
  end
  def is_admin
    if current_user != nil
      if !current_user.admin
        redirect_to root_path
      elsif !current_user.email_verify
        redirect_to "/verify/#{current_user.id}?resend=t"
      end
    else
      redirect_to root_path
    end
  end
  def my_family
    @family = Family.find(params[:id])
    user = params[:user]
    if user == "undefined"
      user = current_user.id
    end
    user ||= current_user.id
    @items = @family.items.isMine user.to_i
    @user = User.find(user.to_i)
  end
  def family_admin
    @family = Family.find(params[:id])
    @donated = @family.items.donated
    @available = @family.items.available
  end
  def family_deliver
    @family = Family.find(params[:id])
  end
  def delivery_is_sent
    @family = Family.find(params[:id])
    @family.update_attribute("delivered",true)
    redirect_to "/admin", alert: "Delivery Has Been Sent"
  end
  def revoke_delivery
    @family = Family.find(params[:id])
    @family.update_attribute("delivered",false)
    redirect_to "/admin", alert: "Delivery Has Been Revoked"
  end
  def address_exist
    @family = Family.find(params[:id])
    if @family.address == nil
      redirect_to edit_family_path(@family), alert: "Please Set the Address For this Family Before Proceding."
    end
  end
  def api
    Family.all.each do |f|
      f.update_attribute("lf",f.items.available.length)
      tot = 0
      f.items.available.each do |i|
        tot += i.totalCost
      end
      f.update_attribute("cost",tot)
    end
    if params[:mine] == "true"
      @families = Family.all.isMine current_user.id
    elsif params[:mode] == "price" and params[:cost] == "on"
      @families = Family.expensive.available
    elsif params[:mode] == "item"
      if params[:item] == "on"
        @families = Family.mostItems.available
      else
        @families = Family.leastItems.available
      end
    elsif params[:mode] == "admin"
        @families = Family.all.needs
    elsif params[:mode] == "donor"
        @families = Family.all.isMine params[:donor].to_i
    elsif params[:mode] == "recieved"
        @families = Family.all.isRecieved.select{ |f| !f.delivered }
    elsif params[:mode] == "delivered"
        @families = Family.all.isDelivered
    else
      @families = Family.cheapest.available
    end
    data = [];
    @families.each do |f|
      h = {name: f.name,cost: f.cost,left: f.lf,items: f.items,id: f.id }
      if current_user != nil
        h[:myCost] = f.myCost current_user.id
        temp = f.items.isMine current_user.id
        h[:myItems] = temp.length
      end
      if params[:donor] != nil && params[:donor] != "undefined"
        h[:myCost] = f.myCost params[:donor].to_i
        temp = f.items.isMine params[:donor].to_i
        h[:myItems] = temp.length
        h[:recieved] = f.areMineRecieved params[:donor].to_i
      end
      data.push(h)
    end
    render json: data
  end
end
