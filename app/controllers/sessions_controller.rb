class SessionsController < ApplicationController

  skip_before_action :current_user, only: [:log_out]

  def log_in
  	session[:current_account] = nil
  	current_user
	  redirect_to current_user
  end

  def log_out
  	@current_user = nil
  	session[:cas_user] = nil
    session[:current_account] = nil
    RubyCAS::Filter.logout(self, root_path)
  end
end
