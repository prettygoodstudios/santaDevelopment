class PageController < ActionController::Base
  layout 'application'
  before_action :is_logged, only: [:index]
  before_action :is_admin, only: [:admin,:donor,:contact]
  def index
      @families = Family.cheapest.available
      if params[:mode] == "price" and params[:cost] == "on"
        @families = Family.expensive.available
      elsif params[:mode] == "item"
        if params[:item] == "on"
          @families = Family.mostItems.available
        else
          @families = Family.leastItems.available
        end
      end
      @items =  Item.all.available
  end
  def admin
      @items = Item.all.donated
      @recieved = Item.all.recieved
      @available = Item.all.available
      @donors = User.all.donor
  end
  def contact
    @user = User.find(params[:id])

  end
  def landing

  end
  def sendEmail
    @user = User.find(params[:id])
    UserMailer.contact_alert(@user,params[:message],params[:subject]).deliver_now
    redirect_to "/admin", alert: "Email has been sent."
  end
  def donor
    @donor = User.find(params[:id])
  end
  def is_admin
    if current_user != nil
      if !current_user.admin
        redirect_to root_path, alert: "You must be an admin."
      elsif !current_user.email_verify
        redirect_to "/verify/#{current_user.id}?resend=t"
      end
    else
      redirect_to root_path, alert: "You must be an admin."
    end
  end
  def is_logged
    if current_user == nil
      redirect_to "/landing"
    elsif !current_user.email_verify
      redirect_to "/verify/#{current_user.id}?resend=t"
    end
  end
end
