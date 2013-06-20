require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success    
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {@user.first_name => "Lebron", @user.last_name => "James",  @user.biography => "I play for the Miami Heat", @user.current_location => "South Beach", @user.netid => "lbj1", @user.handle => "kingjames"  }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    #puts @user.first_name.to_s
    get :show, id: @user.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user.id, user: {@user.first_name => "Lebron", @user.last_name => "James",  @user.biography => "I play for the Miami Heat", @user.current_location => "South Beach", @user.netid => "lbj1", @user.handle => "kingjames" }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user.id
    end

    assert_redirected_to users_path
  end



end
