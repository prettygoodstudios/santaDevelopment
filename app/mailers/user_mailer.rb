class UserMailer < ApplicationMailer
  def contact(donor)
    @donor = User.find(donor.id)
    @items  = @donor.message
    @contact = true
    mail(to: @donor.email, subject: "Sunshine Heroes Donation Update")
  end
  def contact_alert(donor,message,subject)
    @donor = User.find(donor.id)
    @contact = false
    @message = message
    mail(to: @donor.email, subject: subject)
  end
  def verify_account(user,token)
    @user = User.find(user.id)
    @token = token
    mail(to: @user.email, subject: "Sub For Santa Email Verification")
  end
  def remove_item(user,items)
    @user = User.find(user.id)
    @items = items.chomp(",")
    mail(to: @user.email, subject: "Sub For Santa Removed Items")
  end
end
