class UserController < ActionController::Base
  layout 'application'
  before_action :signed_in, only: [:show]
  before_action :not_verified, only: [:verify,:sendverify,:checkToken]
  def show
    @familys = Family.all.isMine current_user.id
  end
  def verify
    if current_user != nil
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    if params[:resend] == "t"
      @user.update_attribute("token",rand(36**15).to_s(36))
      UserMailer.verify_account(@user,@user.token).deliver_now
    end
  end
  def checkToken
    @user = User.find(params[:id])
    if @user.token == params[:token]
      @user.update_attribute("email_verify",true)
      redirect_to root_path, alert: "Acount Activated"
    else
      redirect_to "/verify/#{@user.id}", alert: "Incorrect Token! Token Resent!"
    end
  end
  def signed_in
    if current_user == nil
      redirect_to root_path, alert: "You must be logged in to access this page."
    elsif !current_user.email_verify
      redirect_to "/verify/#{current_user.id}?resend=t"
    end
  end
  def not_verified
    if current_user != nil
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    if @user == nil
      redirect_to root_path, alert: "No User is currently selected."
    elsif @user.email_verify
      redirect_to root_path, alert: "Your account is already activated."
    end
  end
end
