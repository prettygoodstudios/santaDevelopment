class ItemController < ActionController::Base
  layout 'application'
  before_action :set_item, only: [:show,:edit,:destroy,:update]
  before_action :is_admin, only: [:edit,:destroy,:create,:new,:update,:recieved]
  before_action :mine_or_admin, only: [:remove_status]
  def index
      @items =  Item.all
  end
  def show
    @family = @item.family
  end
  def edit
    @family = Family.find(Item.find(params[:id]).family_id)
  end
  def destroy
    @family = Family.find(Item.find(params[:id]).family_id)
    @item.destroy!
    familyCost = 0
    @family.items.available.each do |i|
      familyCost += i.totalCost
    end
    @family.update_attribute("cost",familyCost)
    @family.update_attribute("lf", @family.items.available.length)
    redirect_to @family, alert: "Item Deleted"
  end
  def update
    if @item.update(item_params)
      @item.update_attribute("totalCost",@item.quantity*@item.cost)
      family = Family.find(@item.family_id)
      familyCost = 0
      family.items.available.each do |i|
        familyCost += i.totalCost
      end
      family.update_attribute("cost",familyCost)
      family.update_attribute("lf", family.items.available.length)
      redirect_to @item, alert: "Successfully Updated Item."
    else
      error_message = "<ul>".html_safe
      @item.errors.each do |e|
        error_message += "<li>#{@item.errors[e]}</li>".html_safe
      end
      error_message += "</ul>".html_safe
      redirect_to edit_item_path(@item), alert: @item.errors.values.first
    end
  end
  def new
    @family = Family.find(params[:id])
    @item = Item.new
  end
  def create
    @family = Family.find(params[:family])
    @item = @family.items.build(item_params)
    if @item.save
      @item.update_attribute("totalCost",@item.quantity*@item.cost)
      family = Family.find(@item.family_id)
      familyCost = 0
      family.items.available.each do |i|
        familyCost += i.totalCost
      end
      family.update_attribute("cost",familyCost)
      family.update_attribute("lf", family.items.available.length)
      redirect_to @item, alert: "Item Successfully Created."
    else
      redirect_to new_item_path(id: @family.id), alert: @item.errors.values[0]
    end
  end
  def recieved
    @user = User.find(params[:donor])
    @family = Family.all.isMine @user.id
    @family.each do |f|
      if params[f.id.to_s] != nil
        f.items.each do |i|
          i.update_attribute("recieved",true)
        end
      else
        f.items.each do |i|
          i.update_attribute("recieved",false)
        end
      end
    end
    redirect_to "/donor/"+@user.id.to_s, alert: "Status has been updated."
  end
  def remove_status
    failed = false
    itemsRemoved = ""
    user = User.find(current_user.id)
    if user.message == nil
      user.update_attribute("message"," ");
    end
    Family.find(params[:family]).items.each do |i|
      if params[i.id.to_s] != nil
        itemsRemoved += i.name + ","
        i.update_attribute("recieved",false)
        current_user.items.delete(i)
      end
    end
    if !failed
      itemsRemoved.chomp
      family = Family.find(params[:family])
      familyCost = 0
      family.items.available.each do |i|
        familyCost += i.totalCost
      end
      family.update_attribute("cost",familyCost)
      family.update_attribute("lf", family.items.available.length)
      UserMailer.remove_item(user,itemsRemoved).deliver_now
      user.update_attribute("contacted",true)
      user.update_attribute("message"," ");
      redirect_to "/my_family/"+params[:family], alert: "Successfully Removed Items"
      #Put Stuff Here!
    end
  end
  def update_status
    failed = false
    user = User.find(current_user.id)
    if user.message == nil
      user.update_attribute("message"," ");
    end
    Family.find(params[:family]).items.each do |i|
      if params[i.id.to_s] != nil
        if i.user_id == nil
          current_user.items << i
          i.update_attribute("recieved",false)
          user.update_attribute("message",user.message + ", <h5>" + i.name + "</h5><p>Total Cost: "+ActiveSupport::NumberHelper.number_to_currency(i.totalCost) + "</p><p>Quantity: "+i.quantity.to_s + "</p><p>Unit Cost: "+ ActiveSupport::NumberHelper.number_to_currency(i.cost)+"</p><p>Family: "+Family.find(i.family_id).name+"</p> <p>Description: "+i.description+"</p>")
        else
          failed = true
          redirect_to Family.find(params[:family]), alert: "This item has already been donated."
          break
        end
      end
    end
    if !failed
      family = Family.find(params[:family])
      familyCost = 0
      family.items.available.each do |i|
        familyCost += i.totalCost
      end
      family.update_attribute("cost",familyCost)
      family.update_attribute("lf", family.items.available.length)
      UserMailer.contact(user).deliver_now
      user.update_attribute("contacted",true)
      user.update_attribute("message"," ");
      redirect_to "/my_family/"+family.id.to_s, alert: "Item Successfully Added!"
      #Put Stuff Here!
    end
  end
  def set_item
    @item = Item.find(params[:id])
  end
  def item_params
    params.require(:item).permit(:name,:cost,:quantity,:member,:age,:description)
  end
  def mine_or_admin
    if current_user == nil
      redirect_to root_path
    elsif !current_user.email_verify
      redirect_to "/verify/#{current_user.id}?resend=t"
    elsif !(Family.find(params[:family]).mine current_user.id)
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
        redirect_to '/verify/#{current_user.id}?resend=t'
      end
    else
      redirect_to root_path
    end
  end
end
