class UserController < ActionController::Base
  layout 'application'
  before_action :signed_in, only: [:show]
  before_action :not_verified, only: [:verify,:sendverify,:checkToken]
  before_action :is_admin, only:[:phone_user,:create_phone_user,:admin_login]
  def show
    @familys = Family.all.isMine current_user.id
  end
  def phone_user

  end
  def admin_login
    user = User.find(params[:id])
    sign_in :user, user
    redirect_to root_path, alert:  "Forced Logged in as #{user.name}"
  end
  def create_phone_user
    begin
      @user = User.create!(name: params[:name], email: params[:email], phone: params[:phone], password: "admin0101", email_verify: true)
    rescue Exception => e
      redirect_to "/phone_user" , alert: "You must enter a "+ e.message.split(" ")[2].chomp(",")
    ensure
      if @user != nil
        redirect_to "/donor/#{@user.id}",  alert: "Successfully Created User!"
      end
    end
  end
  def new_password
    email = params[:email]
    user = User.all.where(email: email).first
    if user != nil
      password = rand(36**8).to_s(36)
      user.update_attribute("password",password)
      UserMailer.new_password(user,password).deliver_now
      redirect_to new_user_session_path, alert: "Password has been reset check your email."
    else
      redirect_to new_user_password_path, alert: "This email was not found in our system."
    end
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
end
