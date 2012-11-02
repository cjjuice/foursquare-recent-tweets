class UsersController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    redirect_to root_url , notice: 'Welcome aboard! Recent Tweet was successfully connected!' 
  end
end
