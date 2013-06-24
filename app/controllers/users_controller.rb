require 'open-uri'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  skip_before_action RubyCAS::Filter, only: [:index]
  skip_before_action :current_user, only: [:index, :new, :create]

  def index
    @users = User.all
  end

  def show
    @id = params[:id]
    if @id.nil?
      @user = User.find(current_user.id)
    else
      @user = User.find(@id)
    end
  end

  # GET /users/new
  def new
    @user = User.new
    @net_id = session[:cas_user]
    @user.search_ldap(@net_id)
    @user.netid = @net_id
    if !current_user(false)
      @user.default = true
    else
      @user.default = false
    end
  end

  # GET /users/1/edit
  def edit
    @id = params[:id]
    if @id.nil?
      @user = User.find(current_user.id)
    else
      @user = User.find(@id)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.netid = session[:cas_user]
    if !current_user(false)
      @user.default = true
    else
      @user.default = false
    end

    respond_to do |format|
      if @user.save

        format.html { redirect_to root_path(delete: false) }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    @user.tweets.each do |tweet|
      tweet.destroy
    end
    respond_to do |format|
      format.html { redirect_to log_out_path(delete: true) }
      format.json { head :no_content }
    end
  end

  def follow
    @id = params[:id]
    @following = []
    @following << User.find(@id)
  end

  def change
    
  end

  def show_stuff
    @doc = Nokogiri::HTML(open("https://students.yale.edu/facebook/PhotoPage?currentIndex=-1&numberToGet=-1"))
  end

  def default
    @old_default = User.where(netid: session[:cas_user], default: true).first
    @old_default.default = false
    @old_default.save
    @new_default = User.find(params[:id])
    @new_default.default = true
    @new_default.save
    redirect_to users_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :handle, :biography, :current_location, :email)
    end
end
