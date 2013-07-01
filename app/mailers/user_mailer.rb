class UserMailer < ActionMailer::Base
  default from: "admin@fwitter.com"

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000'
    email_with_name = "#{@user.full_name} <#{@user.email}>"
  	mail(to: email_with_name, subject: 'Welcome to Fwitter')
  end
end
