class RelationshipsController < ApplicationController

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user}
      format.js 
    end

    Notification.new(user_id: @user.id, image_url: current_user.image_url, message: "#{current_user.full_name} followed you!")
  
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user}
      format.js
    end

    Notification.new(user_id: @user.id, image_url: current_user.image_url, message: "#{current_user.full_name} unfollowed you!")
  
  end
end