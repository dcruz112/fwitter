class ApplicationController < ActionController::Base
  before_action RubyCAS::Filter
  before_action :current_user
  helper_method :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_user(redirect=true)
    @user_list = User.where(netid: session[:cas_user], default: true)
    if !@user_list.empty?
      if session[:current_account]
        @current_account = User.find(session[:current_account])
      else
        @current_user = @user_list.first
      end
    elsif redirect && !params[:delete]
      redirect_to new_user_path and return
    else
      nil
    end
  end

end
